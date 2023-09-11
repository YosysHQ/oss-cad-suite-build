from src.base import SourceLocation, Target

SourceLocation(
	name = 'mau',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/mau',
	revision = 'origin/main',
	license_file = 'COPYING',
)

Target(
	name = 'mau',
	sources = [ 'mau' ],
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
)
