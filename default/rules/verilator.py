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
	patches = [ 'verilator.diff' ],
	license_file = 'verilator/LICENSE',
	params = { 'BIN_DIRS': 'bin share/verilator/bin', 'PY_DIRS': '' },
)
