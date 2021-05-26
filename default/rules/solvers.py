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
	revision = 'a2af6ea75b994d666c9c175793a70c8945208ba5'
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
	revision = '3dda54ba7e6952060766775c56969ab920430a8a'
)

Target(
	name = 'cvc4',
	sources = [ 'cvc4' ],
)

Target(
	name = 'smt-switch',
	sources = [ 'smt-switch' ],
	dependencies = [ 'cvc4', 'boolector' ],
	patches = [ 'smt-switch-win32.diff' ],
	license_file = 'smt-switch/LICENSE',
)

Target(
	name = 'pono',
	sources = [ 'pono' ],
	dependencies = [ 'smt-switch', 'cvc4', 'boolector' ],
	license_file = 'pono/LICENSE',
	continue_on_error = True,
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
	continue_on_error = True,
)
