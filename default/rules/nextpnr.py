from src.base import SourceLocation, Target

SourceLocation(
	name = 'nextpnr',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/nextpnr',
	revision = 'origin/master',
)

Target(
	name = 'nextpnr-ice40',
	sources = [ 'nextpnr' ],
	dependencies = [ 'icestorm', 'python3', 'nextpnr-bba' ],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
)

Target(
	name = 'nextpnr-ecp5',
	sources = [ 'nextpnr' ],
	dependencies = [ 'prjtrellis', 'python3', 'nextpnr-bba', 'prjtrellis-py' ],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
)

Target(
	name = 'nextpnr-generic',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba' ],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
)

Target(
	name = 'nextpnr-bba',
	sources = [ 'nextpnr' ],
	build_native = True,
)
