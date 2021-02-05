from src.base import SourceLocation, Target

SourceLocation(
	name = 'lingeling',
	vcs = 'git',
	location = 'https://github.com/arminbiere/lingeling',
	revision = 'origin/master'
)

SourceLocation(
	name = 'cadical',
	vcs = 'git',
	location = 'https://github.com/arminbiere/cadical',
	revision = 'origin/master'
)

SourceLocation(
	name = 'btor2tools',
	vcs = 'git',
	location = 'https://github.com/Boolector/btor2tools',
	revision = 'origin/master'
)

SourceLocation(
	name = 'boolector',
	vcs = 'git',
	location = 'https://github.com/Boolector/boolector',
	revision = 'origin/master'
)

Target(
	name = 'boolector',
	sources = [ 'lingeling', 'cadical', 'btor2tools', 'boolector' ],
	patches = [ 'boolector.diff' ],
	license_file = 'boolector/COPYING',
)
