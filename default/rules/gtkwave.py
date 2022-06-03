from src.base import SourceLocation, Target

SourceLocation(
	name = 'gtkwave',
	vcs = 'git',
	location = 'https://github.com/gtkwave/gtkwave',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'gtkwave',
	sources = [ 'gtkwave' ],
	package = 'gtkwave',
)
