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
	resources = [ 'xdot' ],
	license_file = 'yosys/COPYING',
)

Target(
	name = 'xdot',
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	arch = [ 'linux-x64' ],
	sources = [ ],
)
