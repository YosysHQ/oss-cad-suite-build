from src.base import SourceLocation, Target

SourceLocation(
	name = 'gtkwave',
	vcs = 'git',
	location = 'https://github.com/gtkwave/gtkwave',
	revision = 'origin/master',
)

Target(
	name = 'gtkwave',
	sources = [ 'gtkwave' ],
	license_file = 'gtkwave/LICENSE',
	package = 'gtkwave',
)
