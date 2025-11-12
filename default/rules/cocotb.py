from src.base import SourceLocation, Target

SourceLocation(
	name = 'cocotb',
	vcs = 'git',
	location = 'https://github.com/cocotb/cocotb',
	revision = '41564633538c4e7abbd9a397492addf35ec7c7ac',
	license_file = 'LICENSE',
)

Target(
	name = 'cocotb',
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	sources = [ 'cocotb' ],
	arch = [ 'linux-x64', 'linux-arm64', 'darwin-x64', 'darwin-arm64' ],
)
