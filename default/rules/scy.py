from src.base import SourceLocation, Target

SourceLocation(
	name = 'scy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/scy',
	revision = 'origin/main',
	license_file = 'COPYING',
)

Target(
	name = 'scy',
	sources = [ 'scy' ],
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'mau', 'python3' ],
	patches = [ 'python3_package.sh' ],
)
