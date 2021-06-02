from src.base import SourceLocation, Target

# HDL
SourceLocation(
	name = 'nmigen',
	vcs = 'git',
	location = 'https://github.com/nmigen/nmigen',
	revision = 'origin/master',
)

SourceLocation(
	name = 'nmigen-boards',
	vcs = 'git',
	location = 'https://github.com/nmigen/nmigen-boards',
	revision = 'origin/master',
)

SourceLocation(
	name = 'migen',
	vcs = 'git',
	location = 'https://github.com/m-labs/migen',
	revision = 'origin/master',
)

Target(
	name = 'pyhdl',
	sources = [ 'nmigen', 'nmigen-boards', 'migen' ],
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
)
