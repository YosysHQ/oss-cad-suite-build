from rules.base import SourceLocation, Target

SourceLocation(
	name = 'mcy',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/mcy',
	revision = 'origin/master'
)

Target(
	name = 'mcy',
	sources = [ 'mcy' ],
	license_file = 'mcy/COPYING',
)
