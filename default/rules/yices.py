from rules.base import SourceLocation, Target

SourceLocation(
	name = 'yices',
	vcs = 'git',
	location = 'https://github.com/SRI-CSL/yices2',
	revision = 'origin/master'
)

Target(
	name = 'yices',
	sources = [ 'yices' ],
	license_file = 'yices/LICENSE.txt',
)
