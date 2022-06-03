from src.base import SourceLocation, Target

# dfu-util

SourceLocation(
	name = 'dfu-util',
	vcs = 'git',
	location = 'https://git.code.sf.net/p/dfu-util/dfu-util',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'dfu-util',
	sources = [ 'dfu-util' ],
	package = 'programmers',
)

# ecpdap

SourceLocation(
	name = 'ecpdap',
	vcs = 'git',
	location = 'https://github.com/adamgreig/ecpdap',
	revision = 'origin/master',
	license_file = 'LICENSE-MIT',
)

Target(
	name = 'ecpdap',
	sources = [ 'ecpdap' ],
	package = 'programmers',
)

# ecpprog

SourceLocation(
	name = 'ecpprog',
	vcs = 'git',
	location = 'https://github.com/gregdavill/ecpprog',
	revision = 'origin/main',
	license_file = 'COPYING',
)

Target(
	name = 'ecpprog',
	sources = [ 'ecpprog' ],
	package = 'programmers',
)

# fujprog

SourceLocation(
	name = 'fujprog',
	vcs = 'git',
	location = 'https://github.com/kost/fujprog',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'fujprog',
	sources = [ 'fujprog' ],
	patches = [ 'Toolchain-mingw64.cmake' ],
	package = 'programmers',
)

# openfpgaloader

SourceLocation(
	name = 'openfpgaloader',
	vcs = 'git',
	location = 'https://github.com/trabucayre/openFPGALoader',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'openfpgaloader',
	sources = [ 'openfpgaloader' ],
	package = 'programmers',
)

# python based programmers

SourceLocation(
	name = 'black-iceprog',
	vcs = 'git',
	location = 'https://github.com/jpenalbae/black-iceprog',
	revision = 'origin/master',
	license_file = 'LICENSE.txt',
)

SourceLocation(
	name = 'icefunprog',
	vcs = 'git',
	location = 'https://github.com/pitrz/icefunprog',
	revision = 'origin/master',
	license_file = 'license.txt',
)

SourceLocation(
	name = 'tinyfpgab',
	vcs = 'git',
	location = 'https://github.com/tinyfpga/TinyFPGA-B-Series',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'tinyprog',
	vcs = 'git',
	location = 'https://github.com/tinyfpga/TinyFPGA-Bootloader',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'python-programmers',
	sources = [ 'black-iceprog', 'icefunprog', 'tinyfpgab', 'tinyprog'],
    dependencies = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	resources = [ 'python3' ],
	tools = { 
		'black-iceprog': ['black-iceprog'], 
		'icefunprog': ['icefunprog'],
		'tinyfpgab': ['tinyfpgab'],
		'tinyprog': ['tinyprog'],
		'bin2hex': ['bin2hex', 'hex2bin', 'hex2dump', 'hexdiff', 'hexinfo', 'hexmerge'],
		'pyserial': ['pyserial-miniterm', 'pyserial-ports'],
	},
)

# openocd

SourceLocation(
	name = 'openocd',
	vcs = 'git',
	location = 'https://repo.or.cz/openocd.git',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'openocd',
	sources = [ 'openocd' ],
	patches = [ 'openocd.diff' ],
	package = 'programmers',
)

# icesprog

SourceLocation(
	name = 'icesprog',
	vcs = 'git',
	location = 'https://github.com/wuxx/icesugar',
	revision = 'origin/master',
	no_submodules = True,
)

Target(
	name = 'icesprog',
	sources = [ 'icesprog' ],
	package = 'programmers',
)
