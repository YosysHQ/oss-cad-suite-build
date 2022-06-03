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
	resources = [ 'flask' ],
)

SourceLocation(
	name = 'flask',
	vcs = 'git',
	location = 'https://github.com/pallets/flask',
	revision = 'tags/1.1.2',
	license_file = 'LICENSE.rst',
)

Target(
	name = 'flask',
	sources = [ 'flask' ],
	dependencies = [ 'python3' ],
	resources = [ 'python3'],
)
