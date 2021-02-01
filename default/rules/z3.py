from rules.base import SourceLocation, Target

SourceLocation(
	name = 'z3',
	vcs = 'git',
	location = 'https://github.com/Z3Prover/z3',
	revision = 'origin/master'
)

Target(
	name = 'z3',
	sources = [ 'z3' ],
	license_file = 'z3/LICENSE.txt',
)
