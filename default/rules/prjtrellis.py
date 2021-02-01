from rules.base import SourceLocation, Target

SourceLocation(
	name = 'prjtrellis',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/prjtrellis',
	revision = 'origin/master',
)

Target(
	name = 'prjtrellis',
	sources = [ 'prjtrellis' ],
	dependencies = [ 'python3' ],
	license_file = 'prjtrellis/COPYING',
)
