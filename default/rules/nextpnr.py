from src.base import SourceLocation, Target

# main
SourceLocation(
	name = 'nextpnr',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/nextpnr',
	revision = 'origin/master',
)

Target(
	name = 'nextpnr',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'icestorm-bba', 'prjtrellis-bba', 'prjoxide-bba' ],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
)

Target(
	name = 'nextpnr-bba',
	sources = [ 'nextpnr' ],
	build_native = True,
	create_package = False,
)

# architecture specific
SourceLocation(
	name = 'icestorm',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/icestorm',
	revision = 'origin/master',
)

SourceLocation(
	name = 'prjtrellis',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/prjtrellis',
	revision = 'origin/master',
)

SourceLocation(
	name = 'prjoxide',
	vcs = 'git',
	location = 'https://github.com/gatecat/prjoxide',
	revision = 'origin/master',
)

Target(
	name = 'icestorm',
	sources = [ 'icestorm' ],
	license_file = 'icestorm/COPYING',
)

Target(
	name = 'prjtrellis',
	sources = [ 'prjtrellis' ],
	license_file = 'prjtrellis/COPYING',
)

Target(
	name = 'prjoxide',
	sources = [ 'prjoxide' ],
	license_file = 'prjoxide/COPYING',
)

# chip databases

Target(
	name = 'icestorm-bba',
	sources = [ 'nextpnr' ],
	dependencies = [ 'icestorm' ],
	build_native = True,
	create_package = False,
)

Target(
	name = 'prjtrellis-bba',
	sources = [ 'prjtrellis', 'nextpnr' ],
	build_native = True,
	create_package = False,
)

Target(
	name = 'prjoxide-bba',
	sources = [ 'nextpnr' ],
	dependencies = [ 'prjoxide' ],
	build_native = True,
	create_package = False,
)
