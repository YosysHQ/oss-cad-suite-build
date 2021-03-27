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
	resources = [ 'python3', 'python3-pip' ],
	license_file = 'yosys/COPYING',
)
