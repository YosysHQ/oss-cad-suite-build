from src.base import SourceLocation, Target

SourceLocation(
	name = 'libusb',
	vcs = 'git',
	location = 'https://github.com/libusb/libusb',
	revision = 'tags/v1.0.24'
)

SourceLocation(
	name = 'libftdi',
	vcs = 'git',
	location = 'git://developer.intra2net.com/libftdi',
	revision = 'tags/v1.5'
)

Target(
	name = 'utils',
	sources = [ 'libusb', 'libftdi' ],
	package = 'programmers',
)
