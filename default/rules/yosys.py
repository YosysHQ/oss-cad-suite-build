from src.base import SourceLocation, Target

SourceLocation(
	name = 'yosys',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/yosys',
	revision = 'origin/master',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'ghdl-yosys-plugin',
	vcs = 'git',
	location = 'https://github.com/ghdl/ghdl-yosys-plugin',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'graphviz',
	vcs = 'git',
	location = 'https://gitlab.com/graphviz/graphviz',
	revision = 'tags/2.42.2',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'abc',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/abc',
	revision = 'origin/yosys-experimental',
	license_file = 'copyright.txt',
	license_build_only = True,
)

Target(
	name = 'abc',
	sources = [ 'abc'],
	build_native = True, # using this for license only
	license_build_only = True,
)

Target(
	name = 'yosys',
	sources = [ 'yosys'],
	resources = [ 'xdot', 'graphviz' ],
	dependencies = [ 'abc' ],
)

Target(
	name = 'ghdl-yosys-plugin',
	sources = [ 'ghdl-yosys-plugin' ],
	dependencies = [ 'ghdl', 'yosys' ],
	arch = [ 'linux-x64' ],
)

Target(
	name = 'xdot',
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	sources = [ ],
	#license_url = 'https://raw.githubusercontent.com/jrfonseca/xdot.py/master/LICENSE.txt',
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64', 'darwin-x64', 'darwin-arm64' ],
)

Target(
	name = 'graphviz',
	patches = [ 'graphviz_fix.diff' ],
	sources = [ 'graphviz' ],
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64', 'darwin-x64', 'darwin-arm64' ],
)
