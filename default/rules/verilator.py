from src.base import SourceLocation, Target

SourceLocation(
	name = 'verilator',
	vcs = 'git',
	location = 'https://github.com/verilator/verilator',
	revision = 'origin/master',
)

Target(
	name = 'verilator',
	sources = [ 'verilator' ],
	license_file = 'verilator/LICENSE',
)
