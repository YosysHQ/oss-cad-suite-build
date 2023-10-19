from src.base import SourceLocation, Target

SourceLocation(
	name = 'python3',
	vcs = 'git',
	location = 'https://github.com/python/cpython',
	revision = 'tags/v3.11.6',
	license_file = 'LICENSE',
)

Target(
	name = 'python3',
	sources = [ 'python3' ],
	dependencies = [ 'python3-native' ],
	patches = [ 'python38.diff', 'python38-mingw.diff', 'python38-darwin.diff' ],
)

Target(
	name = 'python3-native',
	sources = [ 'python3' ],
	build_native = True,
)

SourceLocation(
	name = 'python2',
	vcs = 'git',
	location = 'https://github.com/python/cpython',
	revision = 'tags/v2.7.18',
	license_file = 'LICENSE',
)

Target(
	name = 'python2',
	sources = [ 'python2' ],
	patches = [ 'python27.diff', 'python27-darwin.diff' ],
)
