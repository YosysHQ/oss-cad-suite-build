from src.base import SourceLocation, Target

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
    dependencies = [ 'python3', 'python3-native' ],
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
