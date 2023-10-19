from src.base import SourceLocation, Target

# HDL
SourceLocation(
	name = 'amaranth',
	vcs = 'git',
	location = 'https://github.com/amaranth-lang/amaranth',
	revision = 'origin/main',
	license_file = 'LICENSE.txt',
)

SourceLocation(
	name = 'amaranth-boards',
	vcs = 'git',
	location = 'https://github.com/amaranth-lang/amaranth-boards',
	revision = 'origin/main',
	license_file = 'LICENSE.txt',
)

SourceLocation(
	name = 'migen',
	vcs = 'git',
	location = 'https://github.com/m-labs/migen',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'pyhdl',
	sources = [ 'amaranth', 'amaranth-boards', 'migen' ],
	dependencies = [ 'python3', 'python3-native' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
)
