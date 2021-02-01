from rules.base import SourceLocation, Target

SourceLocation(
	name = 'sby',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/SymbiYosys',
	revision = 'origin/master'
)

Target(
	name = 'sby',
	sources = [ 'sby' ],
	license_file = 'sby/COPYING',
)
