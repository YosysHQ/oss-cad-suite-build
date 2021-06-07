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
	patches = [ 'verilated.mk.in' ],
	license_file = 'verilator/LICENSE',
	package = 'verilator',
)
