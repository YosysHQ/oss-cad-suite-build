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
	license_file = 'python3/LICENSE',
	no_source_copy = [ 'windows-x64', 'local' ],
)

SourceLocation(
	name = 'python2',
	vcs = 'git',
	location = 'https://github.com/python/cpython',
	revision = 'tags/v2.7.18'
)

Target(
	name = 'python2',
	sources = [ 'python2' ],
	patches = [ 'python27.diff' ],
	license_file = 'python2/LICENSE',
	no_source_copy = [ 'windows-x64', 'local' ],
)
