from src.base import SourceLocation, Target

SourceLocation(
	name = 'mau',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/mau',
	revision = 'origin/main',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'mcy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/mcy',
	revision = 'origin/master',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'scy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/scy',
	revision = 'origin/main',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'sby',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/sby',
	revision = 'origin/master',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'sby-gui',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/sby-gui',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'formal',
	sources = [ 'mau', 'mcy', 'scy', 'sby', 'sby-gui' ],
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
)
