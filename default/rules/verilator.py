from src.base import SourceLocation, Target

SourceLocation(
	name = 'verilator',
	vcs = 'git',
	location = 'https://github.com/verilator/verilator',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'verilator',
	sources = [ 'verilator' ],
	patches = [ 'verilator_patches.py' ],
	package = 'verilator',
)
