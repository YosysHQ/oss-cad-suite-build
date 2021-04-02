from src.base import SourceLocation, Target

SourceLocation(
	name = 'dfu-util',
	vcs = 'git',
	location = 'https://git.code.sf.net/p/dfu-util/dfu-util',
	revision = 'origin/master'
)

Target(
	name = 'dfu-util',
	sources = [ 'dfu-util' ],
	license_file = 'dfu-util/COPYING',
)

SourceLocation(
	name = 'ecpdap',
	vcs = 'git',
	location = 'https://github.com/adamgreig/ecpdap',
	revision = 'origin/master',
)

Target(
	name = 'ecpdap',
	sources = [ 'ecpdap' ],
	license_file = 'ecpdap/LICENSE-MIT',
)

SourceLocation(
	name = 'ecpprog',
	vcs = 'git',
	location = 'https://github.com/gregdavill/ecpprog',
	revision = 'origin/master'
)

Target(
	name = 'ecpprog',
	sources = [ 'ecpprog' ],
	license_file = 'ecpprog/COPYING',
)

SourceLocation(
	name = 'fujprog',
	vcs = 'git',
	location = 'https://github.com/kost/fujprog',
	revision = 'origin/master'
)

Target(
	name = 'fujprog',
	sources = [ 'fujprog' ],
	patches = [ 'boolector.diff', 'Toolchain-mingw64.cmake' ],
	license_file = 'fujprog/LICENSE',
)

SourceLocation(
	name = 'openfpgaloader',
	vcs = 'git',
	location = 'https://github.com/trabucayre/openFPGALoader',
	revision = 'origin/master',
)

Target(
	name = 'openfpgaloader',
	sources = [ 'openfpgaloader' ],
	license_file = 'openfpgaloader/LICENSE',
)
