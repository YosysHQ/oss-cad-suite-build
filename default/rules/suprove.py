from src.base import SourceLocation, Target

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
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64' ],
	license_file = 'suprove/pywrapper/LICENSE',
)
