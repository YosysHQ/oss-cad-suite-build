from src.base import SourceLocation, Target

SourceLocation(
	name = 'prjtrellis',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/prjtrellis',
	revision = 'origin/master',
)

Target(
	name = 'prjtrellis',
	sources = [ 'prjtrellis' ],
	license_file = 'prjtrellis/COPYING',
)

Target(
	name = 'prjtrellis-py',
	sources = [ 'prjtrellis' ],
	build_native = True,
)
