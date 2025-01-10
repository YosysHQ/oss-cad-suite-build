from src.base import SourceLocation, Target

SourceLocation(
	name = 'yosys',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/yosys',
	revision = 'origin/main',
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
	name = 'slang',
	vcs = 'git',
	location = 'https://github.com/MikePopoloski/slang',
	revision = 'origin/master',
	license_file = 'LICENSE',
	license_build_only = True,
)

SourceLocation(
	name = 'yosys-slang-plugin',
	vcs = 'git',
	location = 'https://github.com/povik/yosys-slang',
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
	critical = True,
)

Target(
	name = 'ghdl-yosys-plugin',
	sources = [ 'ghdl-yosys-plugin' ],
	dependencies = [ 'ghdl', 'yosys' ],
	arch = [ 'linux-x64', 'darwin-x64', 'darwin-arm64' ],
)

Target(
	name = 'slang',
	sources = [ 'slang'],
	build_native = True, # using this for license only
	license_build_only = True,
)

Target(
	name = 'yosys-slang-plugin',
	sources = [ 'yosys-slang-plugin' ],
	dependencies = [ 'yosys' ],
    critical = True,
)

SourceLocation(
	name = 'xdot',
	vcs = 'git',
	location = 'https://github.com/jrfonseca/xdot.py',
	revision = '6248c81c21a0fe825089311b17f2c302eea614a2',
	license_file = 'LICENSE.txt',
)

Target(
	name = 'xdot',
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	sources = [ 'xdot' ],
	arch = [ 'linux-x64', 'linux-arm64', 'darwin-x64', 'darwin-arm64' ],
)

Target(
	name = 'graphviz',
	patches = [ 'graphviz_fix.diff' ],
	sources = [ 'graphviz' ],
	arch = [ 'linux-x64', 'linux-arm64', 'darwin-x64', 'darwin-arm64' ],
)
