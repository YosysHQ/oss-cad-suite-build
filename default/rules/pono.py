from rules.base import SourceLocation, Target

SourceLocation(
	name = 'smt-switch',
	vcs = 'git',
	location = 'https://github.com/makaimann/smt-switch',
	revision = 'origin/master'
)

SourceLocation(
	name = 'pono',
	vcs = 'git',
	location = 'https://github.com/upscale-project/pono',
	revision = 'origin/master'
)

Target(
	name = 'smt-switch',
	sources = [ 'smt-switch' ],
	license_file = 'smt-switch/LICENSE',
)

Target(
	name = 'pono',
	sources = [ 'pono' ],
	dependencies = [ 'smt-switch' ],
	license_file = 'pono/LICENSE',
)
