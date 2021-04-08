from src.base import SourceLocation, Target

SourceLocation(
	name = 'gtkwave',
	vcs = 'svn',
	location = 'svn://svn.code.sf.net/p/gtkwave/code/gtkwave3',
	revision = 'HEAD',
)

Target(
	name = 'gtkwave',
	sources = [ 'gtkwave' ],
	license_file = 'gtkwave/COPYING',
)
