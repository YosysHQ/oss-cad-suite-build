from src.base import SourceLocation, Target

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
