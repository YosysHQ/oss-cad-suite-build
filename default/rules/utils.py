from src.base import SourceLocation, Target

# libusb
SourceLocation(
	name = 'libusb',
	vcs = 'git',
	location = 'https://github.com/libusb/libusb',
	revision = 'tags/v1.0.28',
	license_file = 'COPYING',
)

# libftdi
SourceLocation(
	name = 'libftdi',
	vcs = 'git',
	location = 'git://developer.intra2net.com/libftdi',
	revision = 'tags/v1.5',
	license_file = 'LICENSE',
)

# dfu-util

SourceLocation(
	name = 'dfu-util',
	vcs = 'git',
	location = 'https://git.code.sf.net/p/dfu-util/dfu-util',
	revision = 'origin/master',
	license_file = 'COPYING',
)

# ecpdap

SourceLocation(
	name = 'ecpdap',
	vcs = 'git',
	location = 'https://github.com/adamgreig/ecpdap',
	revision = 'origin/master',
	license_file = 'LICENSE-MIT',
)

# ecpprog

SourceLocation(
	name = 'ecpprog',
	vcs = 'git',
	location = 'https://github.com/gregdavill/ecpprog',
	revision = 'origin/main',
	license_file = 'COPYING',
)

# fujprog

SourceLocation(
	name = 'fujprog',
	vcs = 'git',
	location = 'https://github.com/kost/fujprog',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

# openocd

SourceLocation(
	name = 'openocd',
	vcs = 'git',
	location = 'https://repo.or.cz/openocd.git',
	revision = 'b6ee13720688a9860f3397bb89ea171b0fc5ccce',
	license_file = 'COPYING',
)

# iceprogduino

SourceLocation(
	name = 'iceprogduino',
	vcs = 'git',
	location = 'https://github.com/OLIMEX/iCE40HX1K-EVB',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

# icesprog

SourceLocation(
	name = 'icesprog',
	vcs = 'git',
	location = 'https://github.com/wuxx/icesugar',
	revision = 'origin/master',
	no_submodules = True,
)

Target(
	name = 'utils',
	sources = [ 'libusb', 'libftdi', 'dfu-util', 'ecpdap', 'ecpprog', 'fujprog', 'openocd', 'iceprogduino', 'icesprog' ],
	package = 'programmers',
)
