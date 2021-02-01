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
from collections import OrderedDict
from libvcs.shortcuts import create_repo
from libvcs.util import run

sources = dict()
targets = dict()
architectures = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64' ]
native_only_architectures  = [ 'darwin-x64' ]
SOURCES_ROOT = "_sources"
BUILDS_ROOT  = "_builds"
OUTPUTS_ROOT = "_outputs"
SCRIPTS_ROOT = "scripts"
PATCHES_ROOT = "patches"
RULES_ROOT   = "rules"
current_rule_group = ""

class SourceLocation:
	def __init__(self, name, vcs, location, revision):
		self.name = name
		self.location = location
		self.vcs = vcs
		self.revision = revision
		self.hash = None
		sources[name] = self

class Target:
	def __init__(self, name, sources = [], dependencies = [], patches = [], arch = [], license_url = None, license_file = None):
		self.name = name
		self.sources = sources
		self.dependencies = dependencies
		self.patches = patches
		self.license_url = license_url
		self.license_file = license_file
		self.hash = None
		self.built = False
		global current_rule_group
		self.group = current_rule_group
		self.arch = arch
		if name in targets:
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("Overriding ", nl=False, fg="white", bold=True)
			click.secho("{}".format(name), nl=False, fg="yellow", bold=True)
			click.secho("...", fg="white", bold=True)
		else:
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("Loading {}...".format(name), fg="white", bold=True)
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
	click.secho("==> ", fg="green", nl=False, bold=True)
	click.secho("Loading ", fg="white", nl=False, bold=True)
	click.secho("{}".format(group), fg="green", nl=False, bold=True)
	click.secho(" building rules...", fg="white", bold=True)
	if not os.path.exists(rules_dir):
		click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
		click.secho("Path for rule group {} does not exist.".format(group), fg="white")
		sys.exit(-1)
	for cmd_name in sorted(os.listdir(rules_dir)):
		if cmd_name.startswith("__init__") or cmd_name.startswith("base.py"):
			continue
		if cmd_name.endswith(".py"):
			try:
				spec = importlib.util.spec_from_file_location(cmd_name[:-3], os.path.abspath(os.path.join(group, RULES_ROOT, cmd_name)))
				foo = importlib.util.module_from_spec(spec)
				spec.loader.exec_module(foo)
			except Exception as e:
				click.secho("==> ERROR loading : ", fg="red", nl=False, bold=True)
				click.secho(str(e), fg="white")
				sys.exit(-1)

def validateRules():
	click.secho("==> ", fg="green", nl=False, bold=True)
	click.secho("Validate building rules...", fg="white", bold=True)
	usedSources = []
	for t in targets.values():
		for s in t.sources:
			usedSources.append(s)
			if s not in sources.keys():
				click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
				click.secho("Unknown source {} in {} target.".format(s,t.name), fg="white")
				sys.exit(-1)
		for d in t.dependencies:
			if d not in targets.keys():
				click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
				click.secho("Unknown dependancy {} in {} target.".format(d,t.name), fg="white")
				sys.exit(-1)
			if d == t.name:
				click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
				click.secho("Target {} dependent on itself.".format(t.name), fg="white")
				sys.exit(-1)
		for p in t.patches:
			if not os.path.exists(os.path.join(t.group, PATCHES_ROOT, p)):
				click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
				click.secho("Target {} does not have corresponding patch.".format(p), fg="white", bold=True)
				sys.exit(-1)

	for s in sources.keys():
		if s not in usedSources:
			click.secho("==> WARNING : ", fg="yellow", nl=False, bold=True)
			click.secho("Source {} not used in any target.".format(s,t.name), fg="white", bold=True)

def dependencyResolver(target, resolved, unresolved, arch, display):
	node = targets[target]
	needed = True
	if node.arch and arch not in node.arch:
		needed = False
		if display:
			click.secho("==> WARNING : ", fg="yellow", nl=False, bold=True)
			click.secho("Target {} not built for architecture {}.".format(node.name, arch), fg="white", bold=True)
	if needed:
		unresolved.append(node.name)
		for dep in node.dependencies:
			if dep not in resolved:
				if dep in unresolved:
					click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
					click.secho("Circular reference detected: {} -> {}.".format(node.name, dep), fg="white", bold=True)
					sys.exit(-1)
				dependencyResolver(dep, resolved, unresolved, arch, display)
		resolved.append(node.name)
		unresolved.remove(node.name)

def createBuildOrder(target, arch, display):
	resolved = []
	dependencyResolver(target, resolved, [], arch, display)
	return resolved

def createNeededSourceList(target, arch):
	src = []
	for t in createBuildOrder(target, arch, False):
		for s in targets[t].sources:
			if s not in src:
				src.append(s)
	return src

def pullCode(target, arch, no_update):
	click.secho("==> ", fg="green", nl=False, bold=True)
	click.secho("Downloading sources...", fg="white", bold=True)
	for src in createNeededSourceList(target, arch):
		s = sources[src]
		repo_dir = os.path.abspath(os.path.join(SOURCES_ROOT, s.name))
		repo = create_repo(url=s.location, vcs=s.vcs, repo_dir=repo_dir)
		if not os.path.isdir(repo_dir):
			is_cloning = True
		else:
			remote_url = repo.get_remote()
			is_cloning = False
			if remote_url is None:
				click.secho("==> WARNING : ", fg="yellow", nl=False, bold=True)
				click.secho("Destination dir '{}' does not contain repository data. Deleting...".format(s.name), fg="white", bold=True)
				is_cloning = True
				shutil.rmtree(repo_dir)
			elif remote_url!=s.location:
				click.secho("==> WARNING : ", fg="yellow", nl=False, bold=True)
				click.secho("Current source location {} does not match {}. Deleting...".format(remote_url,s.location), fg="white", bold=True)
				is_cloning = True
				shutil.rmtree(repo_dir)

		if is_cloning:
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("[{}] Cloning ".format(s.name), fg="white", nl=False, bold=True)
			click.secho("{}".format(s.location), fg="green", nl=False, bold=True)
			click.secho(" ...", fg="white", bold=True)
			try:
				repo.obtain()
			except Exception as ex:
				click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
				click.secho("Error while cloning repository {}.".format(ex), fg="white", bold=True)
				sys.exit(-1)
		else:
			if not no_update:
				click.secho("  -> ", fg="blue", nl=False, bold=True)
				click.secho("[{}] Updating ".format(s.name), nl=False, fg="white", bold=True)
				click.secho("{}".format(s.location), fg="green", nl=False, bold=True)
				click.secho(" ...", fg="white", bold=True)
				try:
					repo.update_repo()
				except Exception as ex:
					click.secho("\n==> ERROR : ", fg="red", nl=False, bold=True)
					click.secho("Error while updating repository {}.".format(ex), fg="white", bold=True)
					sys.exit(-1)
		if is_cloning or (not no_update):
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("[{}] Checkout ".format(s.name), fg="white", nl=False, bold=True)
			click.secho("{}".format(s.revision), fg="green", nl=False, bold=True)
			click.secho(" ...", fg="white", bold=True)
			repo.checkout(s.revision)
		
		s.hash =  repo.get_revision()

		click.secho("  -> ", fg="blue", nl=False, bold=True)
		click.secho("[{}] Current revision ".format(s.name), fg="white", nl=False, bold=True)			
		click.secho("{}".format(s.hash), fg="green", nl=False, bold=True)
		click.secho(" ...", fg="white", bold=True)			

def removeError(func, path, _):
	click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
	click.secho("Error while deleting {}.".format(path), fg="white", bold=True)
	sys.exit(-1)

def validateTarget(target):
	if target not in targets:
		click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
		click.secho("Target {} does not exist.".format(target), fg="white", bold=True)
		sys.exit(-1)

def validateArch(arch):
	if arch not in architectures:
		click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
		click.secho("Architecture {} does not exist.".format(arch), fg="white", bold=True)
		sys.exit(-1)

def cleanBuild(arch, full):
	if not full:
		validateArch(arch)
		click.secho("==> ", fg="green", nl=False, bold=True)
		click.secho("Cleaning for ", fg="white", nl=False, bold=True)
		click.secho("{}".format(arch), fg="green", nl=False, bold=True)
		click.secho(" architecture...", fg="white", bold=True)

		if (os.path.exists(os.path.join(BUILDS_ROOT, arch))):
			shutil.rmtree(os.path.join(BUILDS_ROOT, arch), onerror=removeError)
		if (os.path.exists(os.path.join(OUTPUTS_ROOT, arch))):
			shutil.rmtree(os.path.join(OUTPUTS_ROOT, arch), onerror=removeError)
	else:
		click.secho("==> ", fg="green", nl=False, bold=True)
		click.secho("Cleaning for all architectures...", fg="white", bold=True)

		if (os.path.exists(BUILDS_ROOT)):
			shutil.rmtree(BUILDS_ROOT, onerror=removeError)
		if (os.path.exists(OUTPUTS_ROOT)):
			shutil.rmtree(OUTPUTS_ROOT, onerror=removeError)
		click.secho("==> ", fg="green", nl=False, bold=True)
		click.secho("Cleaning sources...", fg="white", bold=True)
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

def calculateHash(target, prefix):
	data = []
	for s in sorted(target.sources):
		data.append(sources[s].hash)
	for d in sorted(target.dependencies):
		if targets[d].hash:
			data.append(targets[d].hash)
	for p in sorted(target.patches):
		data.append(hashlib.sha256(open(os.path.join(target.group, PATCHES_ROOT, p), 'rb').read()).hexdigest())
	data.append(hashlib.sha256(open(os.path.join(target.group, SCRIPTS_ROOT, target.name + ".sh"), 'r').read().encode()).hexdigest())
	data.append(prefix)
	return hashlib.sha256('\n'.join(data).encode()).hexdigest()
		
def buildCode(target, arch, nproc, no_clean, force, prefix):
	if arch != getArchitecture() and arch in native_only_architectures:
		click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
		click.secho("Files {} architecture can only be built natively.".format(arch), fg="white")
		sys.exit(-1)
	native = False
	if arch == getArchitecture() and arch in native_only_architectures:
		native = True

	click.secho("==> ", fg="green", nl=False, bold=True)
	click.secho("Building ", fg="white", nl=False, bold=True)
	click.secho("{}".format(target), fg="green", nl=False, bold=True)
	click.secho(" for ", fg="white", nl=False, bold=True)
	if native:
		click.secho("native [{}]".format(arch), fg="green", nl=False, bold=True)
	else:
		click.secho("{}".format(arch), fg="green", nl=False, bold=True)
	click.secho(" architecture...", fg="white", bold=True)

	build_order = createBuildOrder(target, arch, True)
	pos = 0
	for t in build_order:
		pos += 1
		target = targets[t]
		target.hash = calculateHash(target, prefix)
		output_dir = os.path.join(OUTPUTS_ROOT, arch, target.name)

		forceBuild = force
		for dep in sorted(target.dependencies):
			forceBuild = forceBuild or targets[dep].built
		hash_file = os.path.join(output_dir, '.hash')
		if (not forceBuild and os.path.exists(hash_file)):
			if target.hash == open(hash_file, 'r').read():
				click.secho("==> ", fg="green", nl=False, bold=True)
				click.secho("Step [{:2d}/{:2d}] skipping ".format(pos,len(build_order)), fg="white", nl=False, bold=True)
				click.secho("{}".format(target.name), fg="green", nl=False, bold=True)
				click.secho(" ...", fg="white", bold=True)
				continue

		click.secho("==> ", fg="green", nl=False, bold=True)
		click.secho("Step [{:2d}/{:2d}] building ".format(pos,len(build_order)), fg="white", nl=False, bold=True)
		click.secho("{}".format(target.name), fg="green", nl=False, bold=True)
		click.secho(" ...", fg="white", bold=True)

		build_dir = os.path.join(BUILDS_ROOT, arch, target.name)
		if no_clean and os.path.exists(build_dir):
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("Skipping clean of build dir...", fg="white", bold=True)
		else:
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("Remove old build dir...", fg="white", bold=True)
			if os.path.exists(build_dir):
				shutil.rmtree(build_dir, onerror=removeError)
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("Creating build dir...", fg="white", bold=True)
			os.makedirs(build_dir)
			for s in target.sources:
				src_dir = os.path.join(SOURCES_ROOT, s)
				click.secho("  -> ", fg="blue", nl=False, bold=True)
				click.secho("Copy '", fg="white", nl=False, bold=True)
				click.secho("{}".format(s), fg="green", nl=False, bold=True)
				click.secho("' source to build dir...", fg="white", bold=True)
				run(['rsync','-a', src_dir, build_dir])
			for d in target.dependencies:
				dep = targets[d]
				needed = True
				if dep.arch and arch not in dep.arch:
					needed = False
				if needed:
					dep_dir = os.path.join(OUTPUTS_ROOT, arch, d)
					click.secho("  -> ", fg="blue", nl=False, bold=True)
					click.secho("Copy '", fg="white", nl=False, bold=True)
					click.secho("{}".format(d), fg="green", nl=False, bold=True)
					click.secho("' output to build dir...", fg="white", bold=True)
					run(['rsync','-a', dep_dir, build_dir])

		click.secho("  -> ", fg="blue", nl=False, bold=True)
		click.secho("Remove old output dir...", fg="white", bold=True)
		if os.path.exists(output_dir):
			shutil.rmtree(output_dir, onerror=removeError)
		click.secho("  -> ", fg="blue", nl=False, bold=True)
		click.secho("Creating output dir...", fg="white", bold=True)
		os.makedirs(output_dir)

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
		if (native):
			env['STRIP'] = 'strip'
			if (getBuildOS()=='darwin'):
				env['PATH'] =  '/usr/local/opt/gnu-sed/libexec/gnubin:'
				env['PATH'] += '/usr/local/opt/coreutils/libexec/gnubin:'
				env['PATH'] += '/usr/local/opt/qt/bin:'
				env['PATH'] += '/usr/local/opt/bison/bin:'
				env['PATH'] += '/usr/local/opt/flex/bin:'
				env['PATH'] += '/usr/local/opt/openjdk/bin:'
				env['PATH'] += os.environ['PATH']
				env['SHARED_EXT'] = '.dylib'
			else:
				env['PATH'] = os.environ['PATH']
		if os.uname()[0].startswith('MSYS_NT') or os.uname()[0].startswith('MINGW'):
			env.update(os.environ)
		env['LC_ALL'] = 'C'
		env['INSTALL_PREFIX'] = prefix

		scriptfile = tempfile.NamedTemporaryFile()
		scriptfile.write("set -e -x\n".encode())
		scriptfile.write(open(os.path.join(target.group, SCRIPTS_ROOT, target.name + ".sh"), 'r').read().encode())
		scriptfile.flush()

		click.secho("  -> ", fg="blue", nl=False, bold=True)
		click.secho("Compiling...", fg="white", bold=True)
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
		if code!=0:
			click.secho("==> ERROR : ", fg="red", nl=False, bold=True)
			click.secho("Script returned error code {}.".format(code), fg="white", bold=True)
			sys.exit(-1)
		
		click.secho("  -> ", fg="blue", nl=False, bold=True)
		click.secho("Marking build finished...", fg="white", bold=True)
		with open(hash_file, 'w') as f:
			f.write(target.hash)
		target.built = True

		if not no_clean:
			click.secho("  -> ", fg="blue", nl=False, bold=True)
			click.secho("Remove build dir...", fg="white", bold=True)
			if os.path.exists(build_dir):
				shutil.rmtree(build_dir, onerror=removeError)
