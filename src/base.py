import os
import sys
import click
import shutil
import importlib.util
import urllib
import tempfile
import asyncio
import hashlib
import platform
import json
from datetime import datetime
from collections import OrderedDict
from libvcs.shortcuts import create_repo
from libvcs.util import run
from pathlib import Path

sources = dict()
targets = dict()
architectures = [ 'linux-x64', 'darwin-x64', 'windows-x64', 'linux-arm64', 'darwin-arm64']
arch_chain = dict({
	'linux-x64' : None, 
	'darwin-x64' : 'linux-x64', 
	'windows-x64' : 'linux-x64', 
	'linux-arm64' : 'windows-x64', 
	'darwin-arm64' : 'darwin-x64',
})

cargo_target = dict({
	'linux-x64' : 'x86_64-unknown-linux-gnu', 
	'linux-arm64' : 'aarch64-unknown-linux-gnu', 
	'windows-x64' : 'x86_64-pc-windows-gnu', 
	'darwin-x64' : 'x86_64-apple-darwin', 
	'darwin-arm64' : 'aarch64-apple-darwin',
})

SOURCES_ROOT = "_sources"
BUILDS_ROOT  = "_builds"
OUTPUTS_ROOT = "_outputs"
SCRIPTS_ROOT = "scripts"
PATCHES_ROOT = "patches"
RULES_ROOT   = "rules"
current_rule_group = ""

def log_warning(msg):
	click.secho("==> WARNING : ", fg="yellow", nl=False, bold=True)
	click.secho(msg, fg="white", bold=True)

def log_error(msg):
	click.secho("\n==> ERROR : ", fg="red", nl=False, bold=True)
	click.secho(msg, fg="white", bold=True)
	sys.exit(-1)

def log_info(msg):
	click.secho("==> ", fg="green", nl=False, bold=True)
	click.secho(msg, fg="white", bold=True)

def log_info_triple(msg1, msg2, msg3 = " ..."):
	click.secho("==> ", fg="green", nl=False, bold=True)
	click.secho(msg1, fg="white", nl=False, bold=True)
	click.secho(msg2, fg="green", nl=False, bold=True)
	click.secho(msg3, fg="white", bold=True)

def log_step(msg):
	click.secho("  -> ", fg="blue", nl=False, bold=True)
	click.secho(msg, fg="white", bold=True)

def log_step_triple(msg1, msg2, msg3 = " ..."):
	click.secho("  -> ", fg="blue", nl=False, bold=True)
	click.secho(msg1, nl=False, fg="white", bold=True)
	click.secho(msg2, nl=False, fg="green", bold=True)
	click.secho(msg3, fg="white", bold=True)

def get_size(path: str) -> int:
    return sum(p.stat().st_size for p in Path(path).rglob('*'))

class SourceLocation:
	def __init__(self, name, vcs, location, revision, license_url = None, license_file = None, license_build_only = False, no_submodules = False):
		self.name = name
		self.location = location
		self.vcs = vcs
		self.revision = revision
		self.hash = None
		self.license_url = license_url
		self.license_file = license_file
		self.license_build_only = license_build_only
		self.no_submodules = no_submodules
		sources[name] = self

class Target:
	def __init__(self, name, sources = [], dependencies = [], resources = [], patches = [], arch = [], license_build_only = False, top_package = False, build_native = False, release_name = None, gitrev = [], branding = None, readme = None, package = None, tools = None, preload = None, force = False):
		self.name = name
		self.sources = sources
		self.dependencies = dependencies
		self.resources = resources
		self.patches = patches
		self.license_build_only = license_build_only
		self.hash = None
		self.built = False
		self.top_package = top_package
		global current_rule_group
		self.group = current_rule_group
		self.arch = arch
		self.build_native = build_native
		self.gitrev = gitrev
		self.branding = branding
		self.readme = readme
		self.package = package
		self.tools = tools
		self.preload = preload
		self.force = force
		if release_name:
			self.release_name = release_name
		else:
			self.release_name = name
		if name in targets:
			log_step_triple("Overriding ", name)
		else:
			log_step("Loading {} ...".format(name))
		targets[name] = self

def getBuildOS():
	system = platform.system().lower()
	if system.startswith('mingw'):
		system = 'windows'
	return system

def getArchitecture():
	system = getBuildOS()
	machine = platform.machine().lower()
	if machine == 'x86_64':
		machine = 'x64'
	elif machine == 'aarch64':
		machine = 'arm64'
	if system == 'windows':
		machine = 'x64' if platform.architecture()[0] == '64bit' else 'x86'
	return '{}-{}'.format(system, machine)

def loadRules(group):
	global current_rule_group
	current_rule_group = group
	rules_dir = os.path.abspath(os.path.join(group, RULES_ROOT))
	log_info_triple("Loading ", group, " building rules ...")
	if not os.path.exists(rules_dir):
		log_error("Path for rule group {} does not exist.".format(group))
	for cmd_name in sorted(os.listdir(rules_dir)):
		if cmd_name.startswith("__init__") or cmd_name.startswith("base.py"):
			continue
		if cmd_name.endswith(".py"):
			try:
				spec = importlib.util.spec_from_file_location(cmd_name[:-3], os.path.abspath(os.path.join(group, RULES_ROOT, cmd_name)))
				foo = importlib.util.module_from_spec(spec)
				spec.loader.exec_module(foo)
			except Exception as e:
				log_error(str(e))

def validateRules():
	log_info("Validate building rules ...")
	usedSources = []
	for t in targets.values():
		for s in t.sources:
			usedSources.append(s)
			if s not in sources.keys():
				log_error("Unknown source {} in {} target.".format(s,t.name))
		for d in t.dependencies:
			if d not in targets.keys():
				log_error("Unknown dependancy {} in {} target.".format(d,t.name))
			if d == t.name:
				log_error("Target {} dependent on itself.".format(t.name))
		for d in t.resources:
			if d not in targets.keys():
				log_error("Unknown resources {} in {} target.".format(d,t.name))
			if d == t.name:
				log_error("Target {} use resource of itself.".format(t.name))
		for g in t.gitrev:
			if (type(g) is not tuple) or (len(g)!=2):
				log_error("Unknown element '{}' in gitrev for {}.".format(g,t.name))
			if g[0] not in sources.keys():
				log_error("Unknown source {} in gitrev for {} target.".format(g[0],t.name))
		for p in t.patches:
			if not os.path.exists(os.path.join(t.group, PATCHES_ROOT, p)):
				log_error("Target {} does not have corresponding patch '{}'.".format(t.name, p))
		script_name = os.path.join(t.group, SCRIPTS_ROOT, t.name + ".sh")
		if not os.path.exists(script_name) and not t.top_package:
			log_error("Target {} does not have script file '{}'.".format(t.name, script_name))
		if t.branding is None and t.top_package:
			log_error("Target {} does not have branding.".format(t.name))
		if t.readme is None and t.top_package:
			log_error("Target {} does not have README file defined.".format(t.name))
		if (t.readme is not None) and (not os.path.exists(os.path.join(t.group, PATCHES_ROOT, t.readme))):
			log_error("Target {} file for README ( '{}' ) does not exist in patch directory.".format(t.name, t.readme))
		if t.tools is not None:
			if not isinstance(t.tools, dict):
				log_error("Target {} have tools override but not properly defined.".format(t.name))
			for key in t.tools:
				if not isinstance(t.tools[key], list):
					log_error("Target {} have tools override but not properly defined.".format(t.name))
	for s in sources.keys():
		if s not in usedSources:
			log_warning("Source {} not used in any target.".format(s))

def dependencyResolver(target, resolved, unresolved, build_arch, arch, display, is_package):
	node = targets[target]
	needed = True
	if node.arch and build_arch not in node.arch:
		needed = False
		if display:
			log_warning("Target {} not built for architecture {}.".format(node.name, build_arch))
	if needed:
		name = tuple((build_arch,node.name))
		unresolved.append(name)
		for dep in (node.dependencies + (node.resources if is_package else [])):
			if (build_arch,dep) not in resolved:
				if (build_arch,dep) in unresolved:
					log_error("Circular reference detected: {} -> {}.".format(node.name, dep))
				dependencyResolver(dep, resolved, unresolved, arch if (targets[dep].build_native) else build_arch, arch, display, is_package)
		resolved.append(name)
		unresolved.remove(name)

def createBuildOrder(target, build_arch, arch, display):
	resolved = []
	dependencyResolver(target, resolved, [], build_arch, arch, display, targets[target].top_package)
	return list(dict.fromkeys(resolved))

def createNeededSourceList(target, build_arch, arch):
	src = []
	for t in createBuildOrder(target, build_arch, arch, False):
		for s in targets[t[1]].sources:
			if s not in src:
				src.append(s)
	return src

def getDirHash(src, dir):
	s = sources[src]
	repo_dir = os.path.abspath(os.path.join(SOURCES_ROOT, s.name))
	repo = create_repo(url=s.location, vcs=s.vcs, repo_dir=repo_dir, no_submodules=s.no_submodules)
	return repo.get_revision_dir(dir)

def pullCode(target, build_arch, arch, no_update, single):
	log_info("Downloading sources ...")
	if single:
		needed_sources = targets[target].sources
	else:
		needed_sources = createNeededSourceList(target, build_arch, arch)
	for src in needed_sources:
		s = sources[src]
		repo_dir = os.path.abspath(os.path.join(SOURCES_ROOT, s.name))
		repo = create_repo(url=s.location, vcs=s.vcs, repo_dir=repo_dir, no_submodules=s.no_submodules)
		if not os.path.isdir(repo_dir):
			is_cloning = True
		else:
			remote_url = repo.get_remote()
			is_cloning = False
			if remote_url is None:
				log_warning("Destination dir '{}' does not contain repository data. Deleting...".format(s.name))
				is_cloning = True
				shutil.rmtree(repo_dir)
			elif remote_url!=s.location:
				log_warning("Current source location {} does not match {}. Deleting...".format(remote_url,s.location))
				is_cloning = True
				shutil.rmtree(repo_dir)

		if is_cloning:
			log_step_triple("[{}] Cloning ".format(s.name), s.location)
			try:
				repo.obtain()
			except Exception as ex:
				log_error("Error while cloning repository {}.".format(s.location))
		else:
			if not no_update:
				log_step_triple("[{}] Updating ".format(s.name), s.location)
				try:
					repo.update_repo()
				except Exception as ex:
					log_error("Error while updating repository {}.".format(ex))
		if is_cloning or (not no_update):
			log_step_triple("[{}] Checkout ".format(s.name), s.revision)
			repo.checkout(s.revision)
		
		s.hash =  repo.get_revision()

		log_step_triple("[{}] Current revision ".format(s.name), s.hash)

def removeError(func, path, _):
	log_error("Error while deleting {}.".format(path))

def validateTarget(target):
	if target not in targets:
		log_error("Target {} does not exist.".format(target))

def validateArch(arch):
	if arch not in architectures:
		log_error("Architecture {} does not exist.".format(arch))

def cleanBuild(arch, full):
	if not full:
		validateArch(arch)
		log_info_triple("Cleaning for ", arch, " architecture ...")

		if (os.path.exists(os.path.join(BUILDS_ROOT, arch))):
			shutil.rmtree(os.path.join(BUILDS_ROOT, arch), onerror=removeError)
		if (os.path.exists(os.path.join(OUTPUTS_ROOT, arch))):
			shutil.rmtree(os.path.join(OUTPUTS_ROOT, arch), onerror=removeError)
	else:
		log_info("Cleaning for all architectures ...")

		if (os.path.exists(BUILDS_ROOT)):
			shutil.rmtree(BUILDS_ROOT, onerror=removeError)
		if (os.path.exists(OUTPUTS_ROOT)):
			shutil.rmtree(OUTPUTS_ROOT, onerror=removeError)
		log_info("Cleaning sources ...")
		if (os.path.exists(SOURCES_ROOT)):
			shutil.rmtree(SOURCES_ROOT, onerror=removeError)

async def run_process(command, cwd, env):
	# based on https://stackoverflow.com/questions/45664626/use-pythons-pty-to-create-a-live-console
	process = await asyncio.create_subprocess_exec(*command, cwd=cwd, env=env,
			stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE, bufsize=0)
	# Schedule reading from stdout and stderr as asynchronous tasks.
	stdout_f = asyncio.ensure_future(process.stdout.readline())
	stderr_f = asyncio.ensure_future(process.stderr.readline())
	while process.returncode is None:
		# Wait for a line in either stdout or stderr.
		await asyncio.wait((stdout_f, stderr_f), return_when=asyncio.FIRST_COMPLETED)
		if stdout_f.done():
			line = stdout_f.result()
			if line:
				click.secho(line.decode().rstrip())
				stdout_f = asyncio.ensure_future(process.stdout.readline())
		if stderr_f.done():
			line = stderr_f.result()
			if line:
				click.secho(line.decode().rstrip(), fg="yellow")
				stderr_f = asyncio.ensure_future(process.stderr.readline())
	return process.returncode

def run_live(command, cwd=None, env=None):
	return asyncio.get_event_loop().run_until_complete(run_process(command, cwd, env))

def calculateHash(target, arch, build_order):
	data = []
	srcs = set()
	for g in target.gitrev:
		srcs.add(g[0])
	for s in sorted(target.sources):
		if (s not in srcs):
			data.append(sources[s].hash)
		else:
			for g in target.gitrev:
				if (s==g[0]):
					data.append(getDirHash(g[0],g[1]))
	for d in sorted(target.dependencies):
		if targets[d].hash:
			data.append(targets[d].hash)
	if target.top_package:
		resources = set()
		for d in build_order:
			dep = targets[d[1]]
			if (dep and dep.resources):
				for r in dep.resources:
					resources.add(r)
		for d in sorted(list(resources)):
			if targets[d].hash:
				data.append(targets[d].hash)
	for p in sorted(target.patches):
		data.append(hashlib.sha256(open(os.path.join(target.group, PATCHES_ROOT, p), 'rb').read()).hexdigest())
	if (not target.top_package):
		data.append(hashlib.sha256(open(os.path.join(target.group, SCRIPTS_ROOT, target.name + ".sh"), 'r').read().encode()).hexdigest())
	else:
		data.append(hashlib.sha256(open(os.path.join(SCRIPTS_ROOT, "package-" + arch.split('-')[0] + ".sh"), 'r').read().encode()).hexdigest())
	return hashlib.sha256('\n'.join(data).encode()).hexdigest()

def executeBuild(target, arch, prefix, build_dir, output_dir, nproc, pack_sources):
	cwd = os.getcwd()

	env = OrderedDict()
	env['BUILD_OS'] = getBuildOS()
	env['WORK_DIR'] = cwd
	env['BUILD_DIR'] = os.path.abspath(build_dir)
	env['OUTPUT_DIR'] = os.path.abspath(output_dir)
	env['SRC_DIR'] = os.path.abspath(SOURCES_ROOT)
	env['PATCHES_DIR'] = os.path.abspath(os.path.join(target.group, PATCHES_ROOT))
	env['ARCH'] = arch
	env['ARCH_BASE'] = arch.split('-')[0]
	env['NPROC'] = str(nproc)
	env['SHARED_EXT'] = '.so'
	env['PACK_SOURCES'] = 'True' if pack_sources else 'False'
	env['CARGO_HOME'] = "/tmp/" + arch
	env['CARGO_TARGET'] = cargo_target[arch]
	if (arch == 'windows-x64'):
		env['EXE'] = '.exe'
		env['SHARED_EXT'] = '.dll'
	if (arch == 'darwin-x64') or (arch == 'darwin-arm64'):
		env['SHARED_EXT'] = '.dylib'
	env['LC_ALL'] = 'C'
	env['INSTALL_PREFIX'] = prefix
	if (target.branding):
		env['BRANDING'] = str(target.branding)
	if (target.readme):
		env['README'] = str(target.readme)
	if (target.preload):
		env['PRELOAD'] = 'True'

	scriptfile = tempfile.NamedTemporaryFile()
	scriptfile.write("set -e -x\n".encode())
	if (not target.top_package):
		scriptfile.write(open(os.path.join(target.group, SCRIPTS_ROOT, target.name + ".sh"), 'r').read().encode())
	else:
		scriptfile.write(open(os.path.join(SCRIPTS_ROOT, "package-" + arch.split('-')[0] + ".sh"), 'r').read().encode())

	scriptfile.flush()

	log_step("Compiling ...")
	params = ['docker', 
		'run', '--rm',
		'--user', '{}:{}'.format(os.getuid(), os.getgid()),
		'-v', '/tmp:/tmp',
		'-v', '{}:/work'.format(cwd),
		'-w', os.path.join('/work', os.path.relpath(build_dir, os.getcwd())),
	]
	for i, j in env.items():
		if i.endswith('_DIR'):
			params += ['-e', '{}={}'.format(i, os.path.join('/work', os.path.relpath(j, os.getcwd())))]
		else:
			params += ['-e', '{}={}'.format(i, j)]
	params += [
		'yosyshq/cross-'+ arch + ':2.1',
		'bash', scriptfile.name
	]
	return run_live(params, cwd=build_dir)

def create_tar(tar_name, directory, cwd):
	params= [
		'tar',
		'--owner=root', '--group=root',
		'-czf', tar_name, directory
	]
	code = run_live(params, cwd=cwd)
	if code!=0:
		log_error("Script returned error code {}.".format(code))

def create_exe(exe_name, directory, cwd):
	params= [ 
		'docker',
		'run', '--rm',
		'--user', '{}:{}'.format(os.getuid(), os.getgid()),
		'-v', '{}:/pwd'.format(os.path.abspath(cwd)),
		'nicolasalbert/7zip',
		'a',
		'-mx=3',
		'-sfx7zConWin64.sfx',
		exe_name,
		directory
	]
	code = run_live(params, cwd=cwd)
	if code!=0:
		log_error("Script returned error code {}.".format(code))

def buildCode(build_target, build_arch, nproc, force, dry, pack_sources, single, tar):
	log_info_triple("Building ", build_target, " for {} architecture ...".format(build_arch))

	version_string = datetime.now().strftime("%Y%m%d")
	build_order = createBuildOrder(build_target, build_arch, getArchitecture(), True)
	pos = 0
	if single:
		t = build_order[-1]
		arch = t[0]
		target = targets[t[1]]

		deps = target.dependencies
		if build_target == target.name and target.top_package:
			res = set()
			for d in build_order:
				dep = targets[d[1]]
				if (dep and dep.resources):
					for r in dep.resources:
						res.add(r)
			deps += list(res)
		
		target_build_order = []
		target_build_order.append(tuple((build_arch,build_target)))
		total_pos = len(target_build_order) + len(deps)

		for d in deps:
			pos += 1
			dep = targets[d]
			needed = True
			if dep.arch and arch not in dep.arch:
				needed = False
			if needed:
				build_info = ""
				dep_arch = arch
				if (dep.build_native and build_arch != getArchitecture()):
					dep_arch = getArchitecture()
					build_info = " [" + dep_arch + "]"
				output_dir = os.path.join(OUTPUTS_ROOT, dep_arch, dep.name)
				hash_file = os.path.join(output_dir, '.hash')
				log_info_triple("Step [{:2d}/{:2d}] loading hash ".format(pos,total_pos), dep.name + build_info)
				if dry:
					continue
				if (os.path.exists(hash_file)):
					dep.hash = open(hash_file, 'r').read()
				else:
					log_error("Missing hash file for {} does not exist.".format(dep.name + build_info))		
	else:
		target_build_order = build_order
		total_pos = len(target_build_order)

	for t in target_build_order:
		pos += 1
		arch = t[0]
		target = targets[t[1]]
		target.hash = calculateHash(target, arch, build_order)
		build_info = ""
		if (build_arch != arch):
			build_info = " [" + arch + "]"

		output_dir = os.path.join(OUTPUTS_ROOT, arch, target.name)

		forceBuild = force or target.force
		for dep in sorted(target.dependencies):
			forceBuild = forceBuild or targets[dep].built
		hash_file = os.path.join(output_dir, '.hash')
		if (not forceBuild and os.path.exists(hash_file)):
			if target.hash == open(hash_file, 'r').read():				
				log_info_triple("Step [{:2d}/{:2d}] skipping ".format(pos, total_pos), target.name + build_info)
				continue

		log_info_triple("Step [{:2d}/{:2d}] building ".format(pos, total_pos), target.name + build_info)
		if dry:
			continue
		log_step("Remove old output dir ...")
		if os.path.exists(output_dir):
			shutil.rmtree(output_dir, onerror=removeError)
		log_step("Creating output dir ...")
		os.makedirs(output_dir)

		build_dir = os.path.join(BUILDS_ROOT, arch, target.name)
		if not target.top_package:
			log_step("Remove old build dir ...")
			if os.path.exists(build_dir):
				shutil.rmtree(build_dir, onerror=removeError)
			log_step("Creating build dir ...")
			os.makedirs(build_dir)
			for s in target.sources:
				src_dir = os.path.join(SOURCES_ROOT, s)
				log_step_triple("Copy '", s, "' source to build dir ...")
				run(['rsync','-a', src_dir, build_dir])

		deps = target.dependencies
		if t[1] == target.name and target.top_package:
			res = set()
			for d in build_order:
				dep = targets[d[1]]
				if (dep and dep.resources):
					for r in dep.resources:
						res.add(r)
			deps += list(res)

		prefix = "/yosyshq"

		packages = set()
		for d in deps:
			dep = targets[d]
			needed = True
			if dep.arch and arch not in dep.arch:
				needed = False
			if needed:
				dep_build_info = ""
				if (dep.build_native and build_arch != getArchitecture()):
					dep_build_info = " [" + getArchitecture() + "]"
					dep_dir = os.path.join(OUTPUTS_ROOT, getArchitecture(), d)
				else:
					dep_dir = os.path.join(OUTPUTS_ROOT, arch, d)
				if not os.path.exists(dep_dir):
					log_error("Dependency output directory for {} does not exist.".format(d + dep_build_info))
				if not target.top_package:
					log_step_triple("Copy '", d + dep_build_info, "' output to build dir ...")
					run(['rsync','-a', dep_dir, build_dir])
				else:
					if (dep.package):
						packages.add(dep.package)
					log_step_triple("Copy '", d + dep_build_info, "' output to package dir ...")
					run(['rsync','-a', dep_dir+"/", output_dir])

		if target.top_package:
			version_meta = dict({ 'branding': target.branding, 'product':  target.release_name, 'arch': arch, 'version': version_string, 'package_name': target.release_name + "-" + arch + "-" + version_string})
			package_meta = dict.fromkeys(sorted(list(packages)))
			tools_meta = dict.fromkeys(sorted(list(deps)))
			for key in package_meta:
				package_meta[key] = dict({'size': 0, 'files' : [], 'installed' : True })
			for key in tools_meta:
				tools_meta[key] = dict({'files' : [], 'active' : True, 'package' : None })
			for d in deps:
				dep = targets[d]
				needed = True
				if dep.arch and arch not in dep.arch:
					needed = False
				if dep.tools is not None:
					for key in dep.tools:
						tools_meta[key] = dict({'files' : dep.tools[key], 'active' : True, 'package' : dep.package })
					continue
				if needed:
					if (dep.build_native and build_arch != getArchitecture()):
						dep_dir = os.path.join(OUTPUTS_ROOT, getArchitecture(), d)
					else:
						dep_dir = os.path.join(OUTPUTS_ROOT, arch, d)
					if dep.package:
						package_meta[dep.package]['size'] += get_size(dep_dir + prefix)
					for root, _, files in sorted(os.walk(dep_dir)):
						for filename in sorted(files):
							fpath = os.path.join(root, filename).replace(dep_dir,"")
							if fpath.startswith(prefix):
								name = fpath.replace("/yosyshq/","")
								if name.startswith("bin/"):
									tools_meta[dep.name]['files'].append(name[4:])
									tools_meta[dep.name]['package'] = dep.package
								if dep.package:
									package_meta[dep.package]['files'].append(name)
									if name.startswith("bin/") and arch != 'windows-x64':
										package_meta[dep.package]['files'].append("libexec" + name[3:])
			
			metadata = dict({'version' : version_meta, 'packages' : package_meta, 'tools' : tools_meta })
			with open(os.path.join(output_dir, "yosyshq", "share", "manifest.json"), "w") as manifest_file:
				json.dump(metadata, manifest_file)

		code = executeBuild(target, arch, prefix, build_dir if not target.top_package else output_dir, output_dir, nproc, pack_sources)
		if code!=0:
			log_error("Script returned error code {}.".format(code))

		for s in target.sources:
			src = sources[s]
			if src.license_file is not None or src.license_url is not None:
				log_step("Generating license file for {}...".format(src.name))
				license_dir = os.path.join(output_dir + prefix, "license")
				os.makedirs(license_dir, exist_ok = True)
				license_file = os.path.join(license_dir, "LICENSE." + src.name)
				with open(license_file, 'w') as f:
					if src.license_build_only:
						f.write("YosysHQ uses '{}' to build package(s) in its distribution bundle.\n".format(src.name))
					else:
						f.write("YosysHQ embeds '{}' in its distribution bundle.\n".format(src.name))

					if target.name == src.name:
						build_deps = 0
						for dep in target.dependencies:
							if (targets[dep].license_build_only):
								build_deps += 1

						if (build_deps> 0):
							f.write("\nThis package is built using packages: ")
							for dep in target.dependencies:
								if (targets[dep].license_build_only):
									f.write("'{}' ".format(dep))
							f.write("\n")

					f.write("\nBuild is based on folowing sources:\n")
					f.write('=' * 80 + '\n')
					f.write("{} {} checkout revision {}\n".format(src.vcs, src.location, src.hash))

					f.write("\nSoftware is under following license :\n")
					f.write('=' * 80 + '\n')
					if src.license_url is not None:
						log_step("Retrieving license file for {}...".format(target.name))
						try:
							with urllib.request.urlopen(src.license_url) as lf:
								f.write(lf.read().decode('utf-8'))
						except urllib.error.URLError as e:
							log_error(str(e))
					if src.license_file is not None:
						with open(os.path.join(build_dir, src.name, src.license_file), 'r') as lf:
							f.write(lf.read())
					f.write('\n' + '=' * 80 + '\n')
				if target.name == src.name:
					for dep in target.dependencies:
						dep_license_dir = os.path.join(build_dir, dep + prefix, "license")
						log_step("Adding dependancy license file for {} ...".format(dep))
						if os.path.exists(dep_license_dir):
							run(['rsync','-a', dep_license_dir+"/", license_dir])

		if target.top_package:
			if arch == 'windows-x64':
				package_name = target.release_name + "-" + arch + "-" + version_string +".exe"
				log_step("Packing {} ...".format(package_name))
				os.replace(os.path.join(output_dir, "yosyshq"), os.path.join(output_dir, target.release_name))
				create_exe(package_name, target.release_name, output_dir)
			else:
				package_name = target.release_name + "-" + arch + "-" + version_string +".tgz"
				log_step("Packing {} ...".format(package_name))
				os.replace(os.path.join(output_dir, "yosyshq"), os.path.join(output_dir, target.release_name))
				create_tar(package_name, target.release_name, output_dir)

		log_step("Marking build finished ...")
		with open(hash_file, 'w') as f:
			f.write(target.hash)
		target.built = True

		if tar:
			package_name = arch + "-" + target.name +".tgz"
			log_step("Packing {} ...".format(package_name))
			create_tar(package_name, output_dir, ".")

		if not target.top_package:
			log_step("Remove build dir ...")
			if os.path.exists(build_dir):
				shutil.rmtree(build_dir, onerror=removeError)

def generateYaml(target, build_arch, write_to_file):
	log_info_triple("Creating yml for ", target, " [ {} ] architecture ...".format(build_arch))

	build_order = createBuildOrder(target, build_arch, getArchitecture(), True)
	yaml_content =  "name: {}\n\n" \
					"on:\n" \
					"  workflow_dispatch:\n".format(build_arch)
	if build_arch==getArchitecture():
		yaml_content += "  schedule:\n" \
    					"    - cron: '30 0 * * *'\n\n"
	else:	
		yaml_content += "  workflow_run:\n" \
						"    workflows: [ {} ]\n" \
						"    types:\n" \
						"      - completed\n\n".format(arch_chain[build_arch])
	yaml_content += "jobs:\n"

	BUCKET_URL = "https://github.com/yosyshq/oss-cad-suite-build/releases/download/bucket"
	for t in build_order:
		arch = t[0]
		target = targets[t[1]]
		
		if arch != build_arch:
			continue

		deps = target.dependencies.copy()
		if t[1] == target.name and target.top_package:
			res = set()
			for d in build_order:
				dep = targets[d[1]]
				if (dep and dep.resources):
					for r in dep.resources:
						res.add(r)
			deps += list(res)

		needs = []
		needs_download = []
		for d in deps:
			dep = targets[d]
			needed = True
			if dep.arch and arch not in dep.arch:
				needed = False
			if needed:
				if (dep.build_native and build_arch != getArchitecture()):
					name = "{}-{}".format(getArchitecture(), dep.name)
				else:
					name = "{}-{}".format(arch, dep.name)
					needs.append(name)
				needs_download.append(name)

		yaml_content +="  {}-{}:\n".format(arch, target.name)
		yaml_content +="    runs-on: ubuntu-latest\n"
		if not target.top_package:
			yaml_content +="    continue-on-error: true\n"
		if len(needs)==1:
			yaml_content +="    needs: {}\n".format(needs[0])
		elif len(needs)>1:
			yaml_content +="    needs: [ {} ]\n".format(", ".join(sorted(needs)))

		yaml_content +="    steps:\n"
		if target.top_package:
			yaml_content +="      - name: Get current date\n"
			yaml_content +="        id: date\n"
			yaml_content +="        run: echo \"date=$(date +'%Y-%m-%d')\" >> $GITHUB_OUTPUT\n"
		yaml_content +="      - uses: actions/checkout@v4\n"
		yaml_content +="        with:\n"
		yaml_content +="          repository: 'yosyshq/oss-cad-suite-build'\n"
		if not target.top_package:
			yaml_content +="      - name: Cache sources\n"
			yaml_content +="        id: cache-sources\n"
			yaml_content +="        uses: actions/cache@v4\n"
			yaml_content +="        with:\n"
			yaml_content +="          path: _sources\n"
			yaml_content +="          key: cache-sources-{}".format(target.name) + "\n"
			yaml_content +="      - name: Download previous build\n"
			yaml_content +="        run: |\n"
			yaml_content +="          URL=\"{}-{}/{}-{}.tgz\"\n".format(BUCKET_URL, arch, arch, target.name)
			yaml_content +="          if wget --spider \"${URL}\" 2>/dev/null; then\n"
			yaml_content +="              wget -qO- \"${URL}\" --retry-connrefused --read-timeout=20 --timeout=15 --retry-on-http-error=404 | tar xvfz -\n"
			yaml_content +="          else\n"
			yaml_content +="              echo \"Previous version not found in bucket\"\n"
			yaml_content +="          fi\n"
		for n in sorted(needs_download):
			yaml_content +="      - name: Download {}\n".format(n)
			if (n.startswith(arch)):
				yaml_content +="        run: wget -qO- \"{}-{}/{}.tgz\" --retry-connrefused --read-timeout=20 --timeout=15 --retry-on-http-error=404 | tar xvfz -\n".format(BUCKET_URL, arch, n)
			else:
				yaml_content +="        run: wget -qO- \"{}-{}/{}.tgz\" --retry-connrefused --read-timeout=20 --timeout=15 --retry-on-http-error=404 | tar xvfz -\n".format(BUCKET_URL, "linux-x64", n)
		if target.top_package:
			yaml_content +="      - name: Build\n"
			yaml_content +="        run: ./builder.py build --arch={} --target={} --single\n".format(arch, target.name)
			yaml_content +="      - uses: ncipollo/release-action@v1\n"
			yaml_content +="        if: hashFiles('_outputs/{}/{}/*.{}') != ''\n".format(arch, target.name, "exe" if arch=="windows-x64" else "tgz")
			yaml_content +="        with:\n"
			yaml_content +="          allowUpdates: True\n"
			yaml_content +="          omitBody: True\n"
			yaml_content +="          omitBodyDuringUpdate: True\n"
			yaml_content +="          omitNameDuringUpdate: True\n"
			yaml_content +="          tag: ${{ steps.date.outputs.date }}\n"
			yaml_content +="          artifacts: \"_outputs/{}/{}/*.{}\"\n".format(arch, target.name, "exe" if arch=="windows-x64" else "tgz")
			yaml_content +="          token: ${{ secrets.GITHUB_TOKEN }}\n"
		else:
			yaml_content +="      - name: Build\n"
			yaml_content +="        run: ./builder.py build --arch={} --target={} --single --tar\n".format(arch, target.name)
			yaml_content +="      - uses: ncipollo/release-action@v1\n"
			yaml_content +="        if: hashFiles('{}-{}.tgz') != ''\n".format(arch, target.name)
			yaml_content +="        with:\n"
			yaml_content +="          allowUpdates: True\n"
			yaml_content +="          prerelease: True\n"			
			yaml_content +="          omitBody: True\n"
			yaml_content +="          omitBodyDuringUpdate: True\n"
			yaml_content +="          omitNameDuringUpdate: True\n"
			yaml_content +="          tag: bucket-{}\n".format(arch)
			yaml_content +="          artifacts: \"{}-{}.tgz\"\n".format(arch, target.name)
			yaml_content +="          token: ${{ secrets.GITHUB_TOKEN }}\n"
	
	if write_to_file:
		yaml_file = os.path.join(".github", "workflows", "{}.yml".format(arch))
		with open(yaml_file, 'w') as f:
			f.write(yaml_content)
	else:
		print(yaml_content)
