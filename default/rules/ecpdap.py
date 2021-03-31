from src.base import SourceLocation, Target

SourceLocation(
	name = 'ecpdap',
	vcs = 'git',
	location = 'https://github.com/adamgreig/ecpdap',
	revision = 'origin/master',
)

Target(
	name = 'ecpdap',
	sources = [ 'ecpdap' ],
	license_file = 'ecpdap/LICENSE-MIT',
)
