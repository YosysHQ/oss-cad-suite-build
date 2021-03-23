from src.base import SourceLocation, Target

SourceLocation(
	name = 'smt-switch',
	vcs = 'git',
	location = 'https://github.com/makaimann/smt-switch',
	revision = 'c3957b2e7fec8af4fab24df089230c88e523c0e6'
)

SourceLocation(
	name = 'pono',
	vcs = 'git',
	location = 'https://github.com/upscale-project/pono',
	revision = 'origin/master'
)

SourceLocation(
	name = 'cvc4',
	vcs = 'git',
	location = 'https://github.com/CVC4/CVC4.git',
	revision = '35d080bfb56ff96fd41b31ce7025c019193f6abc'
)

Target(
	name = 'smt-switch',
	sources = [ 'smt-switch' ],
	dependencies = [ 'cvc4', 'boolector' ],
	arch = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
	license_file = 'smt-switch/LICENSE',
)

Target(
	name = 'pono',
	sources = [ 'pono' ],
	dependencies = [ 'smt-switch', 'boolector' ],
	arch = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
	license_file = 'pono/LICENSE',
)

Target(
	name = 'cvc4',
	sources = [ 'cvc4' ],
	arch = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
)
