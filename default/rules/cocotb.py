from src.base import SourceLocation, Target

SourceLocation(
	name = 'cocotb',
	vcs = 'git',
	location = 'https://github.com/cocotb/cocotb',
	revision = 'origin/master',
)

Target(
	name = 'cocotb',
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
	patches = [ 'python3_package.sh' ],
	sources = [ 'cocotb' ],
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64', 'darwin-x64' ],	
)
