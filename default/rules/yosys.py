from src.base import SourceLocation, Target

SourceLocation(
	name = 'yosys',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/yosys',
	revision = 'origin/master'
)

SourceLocation(
	name = 'graphviz',
	vcs = 'git',
	location = 'https://gitlab.com/graphviz/graphviz',
	revision = 'tags/2.42.2'
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
	sources = [ ],
)

Target(
	name = 'graphviz',
	#patches = [ 'graphviz_fix.diff' ],
	sources = [ 'graphviz' ],
)
