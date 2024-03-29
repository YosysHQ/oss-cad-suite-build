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
	patches = [ 'python3.11.6-mingw.diff', 'python3.11.6-darwin.diff' ],
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
	dependencies = [ 'python2-native' ],
	patches = [ 'python27.diff'],
)

Target(
	name = 'python2-native',
	sources = [ 'python2' ],
	patches = [ 'python27.diff'],
	build_native = True,
)
