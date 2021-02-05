from src.base import SourceLocation, Target

SourceLocation(
	name = 'sby',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/SymbiYosys',
	revision = 'origin/master'
)

Target(
	name = 'sby',
	sources = [ 'sby' ],
	resources = [ 'python3' ],
	license_file = 'sby/COPYING',
)
