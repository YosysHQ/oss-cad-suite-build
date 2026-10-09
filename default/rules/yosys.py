from src.base import SourceLocation, Target

SourceLocation(
	name = 'yosys',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/yosys',
	revision = 'origin/main',
	license_file = 'COPYING',
	sublicenses = {
		"abc": "abc/copyright.txt",
        "bigint": "libs/bigint/COPYING.txt",
		"boost_regex": "libs/boost_regex/readme.txt",
		"cxxopts": "libs/cxxopts/LICENSE",
        "dlfcn-win32": "libs/dlfcn-win32/COPYING.txt",
        "flex": "libs/flex/COPYING.txt",
		"fmt": "libs/fmt/LICENSE",
        "libfst": "libs/fst/LICENSE.txt",
        "json11": "libs/json11/LICENSE.txt",
		"minisat": "libs/minisat/LICENSE",
        "sha1": "libs/sha1/COPYING.txt",
		"slang": "libs/slang/LICENSE",
		"symfpu": "libs/symfpu/LICENSE-BSD",
		"tomlplusplus": "libs/tomlplusplus/LICENSE",
		"sv-elab": "frontends/slang/lib/LICENSE",
	}
)

SourceLocation(
	name = 'ghdl-yosys-plugin',
	vcs = 'git',
	location = 'https://github.com/ghdl/ghdl-yosys-plugin',
	revision = 'origin/master',
	license_file = 'LICENSE',
)


SourceLocation(
	name = 'yosys-slang-plugin',
	vcs = 'git',
	location = 'https://github.com/povik/yosys-slang',
	revision = 'origin/master',
	license_file = 'LICENSE',
	sublicenses = {
		"fmt": "third_party/fmt/LICENSE",
		"slang": "third_party/slang/LICENSE",
	}
)

SourceLocation(
	name = 'graphviz',
	vcs = 'git',
	location = 'https://gitlab.com/graphviz/graphviz',
	revision = 'tags/2.42.2',
	license_file = 'LICENSE',
)

Target(
	name = 'yosys',
	sources = [ 'yosys'],
	resources = [ 'xdot', 'graphviz' ],
	critical = True,
)

Target(
	name = 'ghdl-yosys-plugin',
	sources = [ 'ghdl-yosys-plugin' ],
	dependencies = [ 'ghdl', 'yosys' ],
	arch = [ 'linux-x64', 'darwin-arm64' ],
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
