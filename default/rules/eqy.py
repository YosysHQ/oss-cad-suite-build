from src.base import SourceLocation, Target

SourceLocation(
	name = 'eqy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/eqy',
	revision = 'origin/main',
	license_file = 'COPYING',
)

Target(
	name = 'eqy',
	sources = [ 'eqy' ],
	dependencies = [ 'yosys' ],
	resources = [ 'python3' ],
)
