from src.base import SourceLocation, Target

SourceLocation(
	name = 'python3',
	vcs = 'git',
	location = 'https://github.com/python/cpython',
	revision = 'tags/v3.8.7'
)

Target(
	name = 'python3',
	sources = [ 'python3' ],
	patches = [ 'python38.diff' ],
	license_file = 'python/LICENSE',
)

SourceLocation(
	name = 'python2',
	vcs = 'git',
	location = 'https://github.com/python/cpython',
	revision = 'tags/2.7'
)

Target(
	name = 'python2',
	sources = [ 'python2' ],
	patches = [ 'python27.diff' ],
	license_file = 'python2/LICENSE',
)
