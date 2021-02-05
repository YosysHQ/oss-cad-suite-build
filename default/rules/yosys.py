from src.base import SourceLocation, Target

SourceLocation(
	name = 'yosys',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/yosys',
	revision = 'origin/master'
)

Target(
	name = 'yosys',
	sources = [ 'yosys' ],
	license_file = 'yosys/COPYING',
)
