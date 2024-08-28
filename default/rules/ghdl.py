from src.base import SourceLocation, Target

SourceLocation(
	name = 'ghdl',
	vcs = 'git',
	location = 'https://github.com/ghdl/ghdl',
	revision = 'origin/master',
	license_file = 'COPYING.md',
)

Target(
	name = 'ghdl',
	sources = [ 'ghdl' ],
	arch = [ 'linux-x64', 'darwin-x64', 'darwin-arm64' ],
)
