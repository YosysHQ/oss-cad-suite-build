from src.base import SourceLocation, Target

# avy
SourceLocation(
	name = 'avy',
	vcs = 'git',
	location = 'https://bitbucket.org/arieg/extavy',
	revision = 'origin/master',
	license_url = 'https://bitbucket.org/arieg/avy/raw/a9685b8ba660e46fc3325797ef059cbe95adaf10/LICENSE',
)

Target(
	name = 'avy',
	sources = [ 'avy' ],
	patches = [ 'avy.diff' ],
)

# bitwuzla

SourceLocation(
	name = 'symfpu',
	vcs = 'git',
	location = 'https://github.com/martin-cs/symfpu',
	revision = '8fbe139bf0071cbe0758d2f6690a546c69ff0053',
	license_file = 'LICENSE',
	license_build_only = True,
)

Target(
	name = 'symfpu',
	sources = [ 'symfpu' ],
	patches = [ 'symfpu_20201114.patch' ],
	license_build_only = True,
	build_native = True, # header only library
)

SourceLocation(
	name = 'bitwuzla',
	vcs = 'git',
	location = 'https://github.com/bitwuzla/bitwuzla',
	revision = '532ca9729136969008960481167ab55696a9cc52',
	license_file = 'COPYING',
)

Target(
	name = 'bitwuzla',
	sources = [ 'bitwuzla' ],
	dependencies = [ 'lingeling', 'cadical', 'btor2tools', 'symfpu' ],
	patches = [ 'Toolchain-mingw64.cmake' ],
)

# boolector

SourceLocation(
	name = 'lingeling',
	vcs = 'git',
	location = 'https://github.com/arminbiere/lingeling',
	revision = 'origin/master',
	license_file = 'COPYING',
	license_build_only = True,
)

Target(
	name = 'lingeling',
	sources = [ 'lingeling' ],
	patches = [ 'Lingeling_20190110.patch' ],
	license_build_only = True,
)

SourceLocation(
	name = 'cadical',
	vcs = 'git',
	location = 'https://github.com/arminbiere/cadical',
	revision = 'e7369b4b04fafe8b4b139d5e181528f5006d0816',
	license_file = 'LICENSE',
	license_build_only = True,
)

Target(
	name = 'cadical',
	sources = [ 'cadical' ],
	patches = [ 'CaDiCaL_20190730.patch' ],
	license_build_only = True,
)

SourceLocation(
	name = 'btor2tools',
	vcs = 'git',
	location = 'https://github.com/Boolector/btor2tools',
	revision = 'd381aefa4560d245a371c1915b1fb89b691d9489',
	license_file = 'LICENSE.txt',
	license_build_only = True,
)

Target(
	name = 'btor2tools',
	sources = [ 'btor2tools' ],
	license_build_only = True,
)

SourceLocation(
	name = 'boolector',
	vcs = 'git',
	location = 'https://github.com/Boolector/boolector',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'boolector',
	sources = [ 'boolector' ],
	dependencies = [ 'lingeling', 'cadical', 'btor2tools' ],
	patches = [ 'Toolchain-mingw64.cmake' ],
)

# pono

SourceLocation(
	name = 'smt-switch',
	vcs = 'git',
	location = 'https://github.com/stanford-centaur/smt-switch',
	revision = '758e9e125dd76bc72b39add7adf8332992c0c527',
	license_file = 'LICENSE',
	license_build_only = True,
)

SourceLocation(
	name = 'pono',
	vcs = 'git',
    location = 'https://github.com/stanford-centaur/pono',
	revision = 'd307bc1539992275c74b594968c91967abeafe17',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'cvc4',
	vcs = 'git',
	location = 'https://github.com/cvc5/cvc5',
	revision = '5247901077efbc7b9016ba35fded7a6ab459a379',
	license_file = 'COPYING',
	license_build_only = True,
)

SourceLocation(
	name = 'cvc5',
	vcs = 'git',
	location = 'https://github.com/cvc5/cvc5',
	revision = '435f2d44f1bb37c4c17d2b59615b7323039b7a62',
	license_file = 'COPYING',
	license_build_only = True,
)

SourceLocation(
	name = 'libpoly',
	vcs = 'git',
	location = 'https://github.com/SRI-CSL/libpoly',
	revision = 'fc54e31f37cbdb5fc72416ad1c2b5e44551ccd7f',
	license_file = 'LICENCE',
	license_build_only = True,
)

Target(
	name = 'libpoly',
	sources = [ 'libpoly' ],
	license_build_only = True,
)

Target(
	name = 'cvc5',
	sources = [ 'cvc5' ],
	dependencies = [ 'libpoly', 'cadical', 'symfpu' ],
	patches = [ 'get-antlr-3.4' ],
	license_build_only = True,
)

Target(
	name = 'cvc4',
	sources = [ 'cvc4' ],
	license_build_only = True,
)

Target(
	name = 'smt-switch',
	sources = [ 'smt-switch' ],
	dependencies = [ 'cvc5', 'boolector', 'cadical', 'bitwuzla'],
	patches = [ 'smt-switch-win32.diff', 'Toolchain-mingw64.cmake' ],
	license_build_only = True,
)

Target(
	name = 'pono',
	sources = [ 'pono' ],
	dependencies = [ 'smt-switch', 'cvc5', 'boolector', 'bitwuzla' ],
)

# suprove

SourceLocation(
	name = 'suprove',
	vcs = 'git',
	location = 'https://github.com/sterin/super-prove-build',
	revision = 'origin/master',
	license_file = 'pywrapper/LICENSE',
)

Target(
	name = 'suprove',
	sources = [ 'suprove' ],
	dependencies = [ 'python2' ],
	resources = [ 'python2' ],
	patches = [ 'suprove.diff' ],
	arch = [ 'linux-x64', 'linux-arm64' ],
)

# yices

SourceLocation(
	name = 'yices',
	vcs = 'git',
	location = 'https://github.com/SRI-CSL/yices2',
	revision = 'origin/master',
	license_file = 'LICENSE.txt',
)

Target(
	name = 'yices',
	sources = [ 'yices' ],
)

# z3

SourceLocation(
	name = 'z3',
	vcs = 'git',
	location = 'https://github.com/Z3Prover/z3',
	revision = 'origin/master',
	license_file = 'LICENSE.txt',
    no_submodules = True,
)

Target(
	name = 'z3',
	sources = [ 'z3' ],
)

# aiger

SourceLocation(
	name = 'aiger',
	vcs = 'git',
	location = 'https://github.com/arminbiere/aiger',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'picosat',
	vcs = 'git',
	location = 'https://github.com/mmicko/picosat',
	revision = 'origin/main',
	license_file = 'LICENSE',
	license_build_only = True,
)

Target(
	name = 'picosat',
	sources = [ 'picosat' ],
	license_build_only = True,
)

Target(
	name = 'aiger',
	sources = [ 'lingeling', 'aiger' ],
	dependencies = [ 'picosat' ],
	arch = [ 'linux-x64', 'linux-arm64', 'darwin-x64', 'darwin-arm64' ],
)
