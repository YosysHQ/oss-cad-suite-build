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
from datetime import datetime
from collections import OrderedDict
from libvcs.shortcuts import create_repo
from libvcs.util import run

sources = dict()
targets = dict()
system = dict()
architectures = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64', 'windows-x64' ]
native_only_architectures  = [ 'darwin-x64' ]
SOURCES_ROOT = "_sources"
BUILDS_ROOT  = "_builds"
OUTPUTS_ROOT = "_outputs"
HASHES_ROOT = "_hashes"
SCRIPTS_ROOT = "scripts"
PATCHES_ROOT = "patches"
RULES_ROOT   = "rules"
SYSTEM_ROOT = "system"
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

class SourceLocation:
	def __init__(self, name, vcs, location, revision, no_submodules = False):
		self.name = name
		self.location = location
		self.vcs = vcs
		self.revision = revision
		self.hash = None
		self.no_submodules = no_submodules
		sources[name] = self

class Target:
	def __init__(self, name, sources = [], dependencies = [], resources = [], patches = [], arch = [], license_url = None, 
				 license_file = None, top_package = False, build_native = False, system = False, params = { 'BIN_DIRS': 'bin', 'PY_DIRS': 'bin' },
				 create_package = True):
		self.name = name
		self.sources = sources
		self.dependencies = dependencies
		self.resources = resources
		self.patches = patches
		self.license_url = license_url
		self.license_file = license_file
		self.hash = None
		self.built = False
		self.top_package = top_package
		global current_rule_group
		self.group = current_rule_group
		self.arch = arch
		self.build_native = build_native
		self.system = system
		self.params = params
		self.create_package = create_package
		if name in targets:
			log_step_triple("Overriding ", name)
		else:
			log_step("Loading {} ...".format(name))
		targets[name] = self

class SystemFiles:
	def __init__(self, name, files):
		self.name = name
		self.files = files
		system[name] = self

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

def loadSystem(arch):
	system_dir = os.path.abspath(os.path.join(SYSTEM_ROOT, arch))
	log_info_triple("Loading ", arch, " system image info ...")
	if not os.path.exists(os.path.join(system_dir,"system.py")):
		log_warning("System image info for {} does not exist.".format(arch))
	else:
		try:
			spec = importlib.util.spec_from_file_location("system", os.path.abspath(os.path.join(SYSTEM_ROOT, arch, "system.py")))
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
		for p in t.patches:
			if not os.path.exists(os.path.join(t.group, PATCHES_ROOT, p)):
				log_error("Target {} does not have corresponding patch '{}'.".format(t.name, p))
		script_name = os.path.join(t.group, SCRIPTS_ROOT, t.name + ".sh")
		if not os.path.exists(script_name):
			log_error("Target {} does not have script file '{}'.".format(t.name, script_name))
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
	return resolved

def createNeededSourceList(target, build_arch, arch):
	src = []
	for t in createBuildOrder(target, build_arch, arch, False):
		for s in targets[t[1]].sources:
			if s not in src:
				src.append(s)
	return src

def pullCode(target, build_arch, arch, no_update):
	log_info("Downloading sources ...")
	for src in createNeededSourceList(target, build_arch, arch):
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
				log_error("Error while cloning repository {}.")
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
	for s in sorted(target.sources):
		data.append(sources[s].hash)
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
	#if target.create_package:
	#	data.append(hashlib.sha256(open(os.path.join(SYSTEM_ROOT, "package-" + arch.split('-')[0] + ".sh"), 'r').read().encode()).hexdigest())
	data.append(hashlib.sha256(open(os.path.join(target.group, SCRIPTS_ROOT, target.name + ".sh"), 'r').read().encode()).hexdigest())
	return hashlib.sha256('\n'.join(data).encode()).hexdigest()

def executeBuild(target, arch, prefix, build_dir, output_dir, native, nproc):
	script = open(os.path.join(target.group, SCRIPTS_ROOT, target.name + ".sh"), 'r').read().encode()
	return executeScript(target, arch, prefix, build_dir, output_dir, native, nproc, script, [])

def executePackaging(target, arch, prefix, build_dir, output_dir, native, nproc, params):
	script = open(os.path.join(SYSTEM_ROOT, "package-" + arch.split('-')[0] + ".sh"), 'r').read().encode()
	return executeScript(target, arch, prefix, build_dir, output_dir, native, nproc, script, params)

def executeScript(target, arch, prefix, build_dir, output_dir, native, nproc, script, params):
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
	if (arch == 'windows-x64'):
		env['EXE'] = '.exe'
		env['SHARED_EXT'] = '.dll'
	if (native):
		env['STRIP'] = 'strip'
		if (getBuildOS()=='darwin'):
			env['PKG_CONFIG_PATH'] = '/usr/local/opt/libffi/lib/pkgconfig'
			env['PATH'] =  '/usr/local/opt/gnu-sed/libexec/gnubin:'
			env['PATH'] += '/usr/local/opt/coreutils/libexec/gnubin:'
			env['PATH'] += '/usr/local/opt/qt5/bin:'
			env['PATH'] += '/usr/local/opt/bison/bin:'
			env['PATH'] += '/usr/local/opt/flex/bin:'
			env['PATH'] += '/usr/local/opt/openjdk/bin:'
			env['PATH'] += '/usr/local/opt/texinfo/bin:'
			env['PATH'] += '~/.cargo/bin/:'
			env['PATH'] += os.environ['PATH']
			env['SHARED_EXT'] = '.dylib'
	env['LC_ALL'] = 'C'
	env['INSTALL_PREFIX'] = prefix
	env.update(params)

	scriptfile = tempfile.NamedTemporaryFile()
	scriptfile.write("set -e -x\n".encode())
	scriptfile.write(script)
	scriptfile.flush()

	if native:
		code = run_live(['bash', scriptfile.name], cwd=build_dir, env=env)
	else:
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
			'yosyshq/cross-'+ arch + ':1.0',
			'bash', scriptfile.name
		]
		code = run_live(params, cwd=build_dir)
	return code

def create_tar(tar_name, directory, cwd):
	params= [
		'tar',
		'--owner=root', '--group=root',
		'-czf', tar_name, directory
	]
	if (getBuildOS()=='darwin'):
		params= [
			'tar',
			'-czf', tar_name, directory
		]
	code = run_live(params, cwd=cwd)
	if code!=0:
		log_error("Script returned error code {}.".format(code))

def buildCode(target, build_arch, nproc, no_clean, force, dry, tar):
	if build_arch != getArchitecture() and build_arch in native_only_architectures:
		log_error("Build for {} architecture can only be built natively.".format(build_arch))
	native = False
	if build_arch == getArchitecture() and build_arch in native_only_architectures:
		native = True

	log_info_triple("Building ", target, " for {} architecture ...".format(build_arch))

	build_order = createBuildOrder(target, build_arch, getArchitecture(), True)
	pos = 0
	for t in build_order:
		pos += 1
		arch = t[0]
		target = targets[t[1]]
		target.hash = calculateHash(target, arch, build_order)
		build_info = ""
		if (build_arch != arch):
			build_info = " [" + arch + "]"

		output_dir = os.path.join(OUTPUTS_ROOT, arch, target.name)

		hash_dir = os.path.join(HASHES_ROOT, arch, target.name)
		hash_file = os.path.join(hash_dir, 'hash')
		os.makedirs(hash_dir, exist_ok=True)

		forceBuild = force
		for dep in sorted(target.dependencies):
			forceBuild = forceBuild or targets[dep].built
		if (not forceBuild and os.path.exists(hash_file)):
			if target.hash == open(hash_file, 'r').read():				
				log_info_triple("Step [{:2d}/{:2d}] skipping ".format(pos,len(build_order)), target.name + build_info)
				continue

		log_info_triple("Step [{:2d}/{:2d}] building ".format(pos,len(build_order)), target.name + build_info)
		if dry:
			continue
		log_step("Remove old output dir ...")
		if os.path.exists(output_dir):
			shutil.rmtree(output_dir, onerror=removeError)
		log_step("Creating output dir ...")
		os.makedirs(output_dir)

		build_dir = os.path.join(BUILDS_ROOT, arch, target.name)
		if no_clean and os.path.exists(build_dir):
			log_step("Skipping clean of build dir ...")
		else:
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
					if not target.top_package:
						log_step_triple("Copy '", d + dep_build_info, "' output to build dir ...")
						run(['rsync','-a', dep_dir, build_dir])
					else:
						log_step_triple("Copy '", d + dep_build_info, "' output to package dir ...")
						run(['rsync','-a', dep_dir+"/", output_dir])


		prefix = "/packages/" + target.name
		if target.system or target.top_package:
			prefix = "/"
		log_step("Compiling ...")
		code = executeBuild(target, arch, prefix, build_dir if not target.top_package else output_dir, output_dir, native, nproc)
		if code!=0:
			log_error("Script returned error code {}.".format(code))

		if target.system:
			log_step("Generating system file list ...")
			system_dir = os.path.join(SYSTEM_ROOT, arch)
			os.makedirs(system_dir, exist_ok=True)
			system_file = os.path.join(system_dir, "system.py")
			with open(system_file, 'w') as f:
				f.write("from src.base import SystemFiles\n\n")
				f.write("SystemFiles(\n")
				f.write("	name = '" + arch+ "',\n")
				f.write("	files = [\n")
				for item in sorted(os.scandir(os.path.join(output_dir,"lib")), key=lambda f: f.name):
					if item.is_file() and not item.name.startswith("ld-linux"):
						f.write("		'" +item.name + "',\n")
				f.write("	],\n")
				f.write(")\n")

		if target.create_package:
			log_step("Package software ...")
			code = executePackaging(target, arch, prefix, build_dir if not target.top_package else output_dir, output_dir, native, nproc, target.params)
			if code!=0:
				log_error("Script returned error code {}.".format(code))

			libdir = os.path.join(output_dir + prefix, "lib")
			if os.path.exists(libdir):
				log_step("Removing libraries contained in system package ...")
				for item in os.scandir(libdir):
					if item.is_file() and item.name in system[arch].files:
						os.remove(item)
			if target.resources:
				for r in target.resources:
					if r in target.dependencies:
						log_step("Removing libraries contained in '{}' package ...".format(r))
						files = []
						res_lib_dir = os.path.join(build_dir, r, "packages/" + r , "lib")
						if os.path.exists(res_lib_dir):
							for item in os.scandir(res_lib_dir):
								if item.is_file():
									files.append(item.name)
							for item in os.scandir(libdir):
								if item.is_file() and item.name in files and not item.name.startswith("ld-linux"):
									os.remove(item)				

		if target.license_file is not None or target.license_url is not None:
			log_step("Generating license file ...")
			license_dir = os.path.join(output_dir + prefix, "license")
			os.makedirs(license_dir)
			license_file = os.path.join(license_dir, "LICENSE." + target.name)
			with open(license_file, 'w') as f:
				f.write("YosysHQ embeds '{}' in its distribution bundle.\n".format(target.name))
				f.write("\nBuild is based on folowing sources:\n")
				f.write('=' * 80 + '\n')
				for s in target.sources:
					f.write("{} {} checkout revision {}\n".format(sources[s].vcs, sources[s].location, sources[s].hash))
				f.write("\nFollowing files are included:\n")
				f.write('=' * 80 + '\n')
				for root, _, files in sorted(os.walk(output_dir)):
					for filename in sorted(files):
						fpath = os.path.join(root, filename).replace(output_dir,"")
						if not fpath.startswith("/dev") and not filename.startswith("ld-linux"):
							f.write(fpath + '\n')
				f.write("\nSoftware is under following license :\n")
				f.write('=' * 80 + '\n')
				if target.license_url is not None:
					log_step("Retrieving license file for {}...".format(target.name))
					try:
						with urllib.request.urlopen(target.license_url) as lf:
							f.write(lf.read().decode('utf-8'))
					except urllib.error.URLError as e:
						log_error(str(e))
				if target.license_file is not None:
					with open(os.path.join(build_dir, target.license_file), 'r') as lf:
						f.write(lf.read())
				f.write('\n' + '=' * 80 + '\n')

		if tar:
			if target.create_package:
				package_dir = os.path.join(output_dir + "/packages")
				package_name = target.name + "-" + arch + ".tgz"
				log_step("Creating {} package ...".format(package_name))
				create_tar("../" + package_name, target.name, package_dir)

			if target.system:
				package_dir = os.path.join(output_dir)
				package_name = target.name + "-" + arch + ".tgz"
				log_step("Creating {} system image ...".format(package_name))
				create_tar("../" + package_name, ".", package_dir)
				os.replace(os.path.join(package_dir,"../" + package_name),os.path.join(package_dir, package_name))

			if target.top_package:
				package_dir = os.path.join(output_dir)
				package_name = ("fpga-nightly" if (target.name=="default") else target.name) + "-" + arch + "-" + datetime.now().strftime("%Y%m%d") +".tgz"
				log_step("Creating {} main image ...".format(package_name))
				create_tar("../" + package_name, ".", package_dir)
				os.replace(os.path.join(package_dir,"../" + package_name),os.path.join(package_dir, package_name))

		log_step("Marking build finished ...")
		with open(hash_file, 'w') as f:
			f.write(target.hash)
		target.built = True

		if not no_clean and not target.top_package:
			log_step("Remove build dir ...")
			if os.path.exists(build_dir):
				shutil.rmtree(build_dir, onerror=removeError)
