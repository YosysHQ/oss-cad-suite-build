from src.base import SourceLocation, Target

SourceLocation(
	name = 'dfu-util',
	vcs = 'git',
	location = 'https://git.code.sf.net/p/dfu-util/dfu-util',
	revision = 'origin/master'
)

Target(
	name = 'dfu-util',
	sources = [ 'dfu-util' ],
	license_file = 'dfu-util/COPYING',
)
