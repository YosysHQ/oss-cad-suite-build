from src.base import SourceLocation, Target

# avy
SourceLocation(
	name = 'avy',
	vcs = 'git',
	location = 'https://bitbucket.org/arieg/extavy',
	revision = 'origin/master',
)

Target(
	name = 'avy',
	sources = [ 'avy' ],
	patches = [ 'avy.diff' ],
	license_url = 'https://bitbucket.org/arieg/avy/raw/a9685b8ba660e46fc3325797ef059cbe95adaf10/LICENSE',
)

# boolector

SourceLocation(
	name = 'lingeling',
	vcs = 'git',
	location = 'https://github.com/arminbiere/lingeling',
	revision = 'origin/master'
)

SourceLocation(
	name = 'cadical',
	vcs = 'git',
	location = 'https://github.com/arminbiere/cadical',
	revision = 'origin/master'
)

SourceLocation(
	name = 'btor2tools',
	vcs = 'git',
	location = 'https://github.com/Boolector/btor2tools',
	revision = 'origin/master'
)

SourceLocation(
	name = 'boolector',
	vcs = 'git',
	location = 'https://github.com/Boolector/boolector',
	revision = 'origin/master'
)

Target(
	name = 'boolector',
	sources = [ 'lingeling', 'cadical', 'btor2tools', 'boolector' ],
	patches = [ 'boolector.diff', 'Toolchain-mingw64.cmake' ],
	license_file = 'boolector/COPYING',
)

# pono

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
	name = 'cvc4',
	sources = [ 'cvc4' ],
	arch = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
	create_package = False,
)

Target(
	name = 'smt-switch',
	sources = [ 'smt-switch' ],
	dependencies = [ 'cvc4', 'boolector' ],
	arch = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
	license_file = 'smt-switch/LICENSE',
	create_package = False,
)

Target(
	name = 'pono',
	sources = [ 'pono' ],
	dependencies = [ 'smt-switch', 'boolector' ],
	arch = [ 'linux-x64', 'darwin-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
	license_file = 'pono/LICENSE',
)

# suprove

SourceLocation(
	name = 'suprove',
	vcs = 'git',
	location = 'https://github.com/sterin/super-prove-build',
	revision = 'origin/master'
)

Target(
	name = 'suprove',
	sources = [ 'suprove' ],
	dependencies = [ 'python2' ],
	resources = [ 'python2' ],
	patches = [ 'suprove.diff' ],
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64' ],
	license_file = 'suprove/pywrapper/LICENSE',
	params = { 'BIN_DIRS': 'super_prove/bin', 'PY_DIRS': '' },
)

# yices

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

# z3

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
