from rules.base import SourceLocation, Target

SourceLocation(
	name = 'sby-gui',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/sby-gui',
	revision = 'origin/master'
)

Target(
	name = 'sby-gui',
	sources = [ 'sby-gui' ],
	resources = [ 'qt5-resources' ],
	license_file = 'sby-gui/COPYING',
)
