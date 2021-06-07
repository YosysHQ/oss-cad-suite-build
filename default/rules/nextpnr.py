from src.base import SourceLocation, Target

# main
SourceLocation(
	name = 'nextpnr',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/nextpnr',
	revision = 'origin/master',
)

Target(
	name = 'nextpnr-bba',
	sources = [ 'nextpnr' ],
	build_native = True,
	gitrev = [ ('nextpnr', 'bba') ],
)

Target(
	name = 'nextpnr-generic',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba'],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
)

Target(
	name = 'nextpnr-ice40',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'icestorm-bba'],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
	package = 'ice40',
)

Target(
	name = 'nextpnr-ecp5',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'prjtrellis-bba'],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
	package = 'ecp5',
)

Target(
	name = 'nextpnr-machxo2',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'prjtrellis-bba'],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
)

Target(
	name = 'nextpnr-nexus',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'prjoxide-bba' ],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
	package = 'nexus',
)

Target(
	name = 'nextpnr-mistral',
	sources = [ 'nextpnr', 'mistral' ],
	dependencies = [ 'python3', 'nextpnr-bba' ],
	resources = [ 'python3' ],
	license_file = 'nextpnr/COPYING',
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

SourceLocation(
	name = 'mistral',
	vcs = 'git',
	location = 'https://github.com/Ravenslofty/mistral',
	revision = 'origin/master',
)

Target(
	name = 'icestorm',
	sources = [ 'icestorm' ],
	license_file = 'icestorm/COPYING',
	package = 'ice40',
)

Target(
	name = 'prjtrellis',
	sources = [ 'prjtrellis' ],
	license_file = 'prjtrellis/COPYING',
	package = 'ecp5',
)

Target(
	name = 'prjoxide',
	sources = [ 'prjoxide' ],
	license_file = 'prjoxide/COPYING',
	package = 'nexus',
)

# chip databases

Target(
	name = 'icestorm-bba',
	sources = [ 'nextpnr' ],
	dependencies = [ 'icestorm' ],
	gitrev = [ ('nextpnr', 'ice40') ],
	build_native = True,
)

Target(
	name = 'prjtrellis-bba',
	sources = [ 'prjtrellis', 'nextpnr' ],
	gitrev = [ ('nextpnr', 'ecp5'), ('nextpnr', 'machxo2') ],
	build_native = True,
)

Target(
	name = 'prjoxide-bba',
	sources = [ 'nextpnr' ],
	dependencies = [ 'prjoxide' ],
	gitrev = [ ('nextpnr', 'nexus') ],
	build_native = True,
)
