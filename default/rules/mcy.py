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
	resources = [ 'flask', 'qt5-resources' ],
	license_file = 'mcy/COPYING',
)

SourceLocation(
	name = 'flask',
	vcs = 'git',
	location = 'https://github.com/pallets/flask',
	revision = 'tags/1.1.2',
)

Target(
	name = 'flask',
	sources = [ 'flask' ],
	dependencies = [ 'python3' ],
	resources = [ 'python3'],
	license_file = 'flask/LICENSE.rst',
)
