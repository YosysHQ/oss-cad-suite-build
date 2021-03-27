from src.base import SourceLocation, Target

SourceLocation(
	name = 'mcy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/mcy',
	revision = 'origin/master'
)

Target(
	name = 'mcy',
	sources = [ 'mcy' ],
	resources = [ 'python3', 'python3-pip', 'qt5-resources' ],
	license_file = 'mcy/COPYING',
)
