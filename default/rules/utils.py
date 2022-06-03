from src.base import SourceLocation, Target

SourceLocation(
	name = 'libusb',
	vcs = 'git',
	location = 'https://github.com/libusb/libusb',
	revision = 'tags/v1.0.24',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'libftdi',
	vcs = 'git',
	location = 'git://developer.intra2net.com/libftdi',
	revision = 'tags/v1.5',
	license_file = 'LICENSE',
)

Target(
	name = 'utils',
	sources = [ 'libusb', 'libftdi' ],
	package = 'programmers',
	tools = { 'libusb': ['libusb'], 'libftdi': ['libftdi'] },
)
