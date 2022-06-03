from src.base import SourceLocation, Target

SourceLocation(
	name = 'sby',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/sby',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'sby',
	sources = [ 'sby' ],
	resources = [ 'python3' ],
)

SourceLocation(
	name = 'sby-gui',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/sby-gui',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'sby-gui',
	sources = [ 'sby-gui' ],
)
