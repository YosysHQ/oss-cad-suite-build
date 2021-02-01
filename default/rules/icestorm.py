from rules.base import SourceLocation, Target

SourceLocation(
	name = 'icestorm',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/icestorm',
	revision = 'origin/master',
)

Target(
	name = 'icestorm',
	sources = [ 'icestorm' ],
	license_file = 'icestorm/COPYING',
)
