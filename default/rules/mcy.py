from src.base import SourceLocation, Target

SourceLocation(
	name = 'mcy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/mcy',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'mcy',
	sources = [ 'mcy' ],
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'python3'],
)
