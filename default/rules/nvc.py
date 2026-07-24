from src.base import SourceLocation, Target

SourceLocation(
	name = 'nvc',
	vcs = 'git',
	location = 'https://github.com/nickg/nvc',
	revision = 'tags/r1.21.1',
	license_file = 'COPYING',
)

Target(
	name = 'nvc',
	sources = [ 'nvc' ],
	arch = [ 'linux-x64' ],
)
