from src.base import SourceLocation, Target

SourceLocation(
	name = 'cocotb',
	vcs = 'git',
	location = 'https://github.com/cocotb/cocotb',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'cocotb',
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	sources = [ 'cocotb' ],
	arch = [ 'linux-x64', 'linux-arm64', 'darwin-x64' ],
)
