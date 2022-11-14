from src.base import SourceLocation, Target

# main
SourceLocation(
	name = 'nextpnr',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/nextpnr',
	revision = 'origin/master',
	license_file = 'COPYING',
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
)

Target(
	name = 'nextpnr-ice40',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'icestorm-bba'],
	resources = [ 'python3' ],
	package = 'ice40',
)

Target(
	name = 'nextpnr-ecp5',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'prjtrellis-bba'],
	resources = [ 'python3' ],
	package = 'ecp5',
)

Target(
	name = 'nextpnr-machxo2',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'prjtrellis-bba'],
	resources = [ 'python3' ],
	package = 'ecp5', # using same prjtrellis base
)

Target(
	name = 'nextpnr-nexus',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'prjoxide-bba' ],
	resources = [ 'python3' ],
	package = 'nexus',
)

Target(
	name = 'nextpnr-mistral',
	sources = [ 'nextpnr', 'mistral' ],
	dependencies = [ 'python3', 'nextpnr-bba' ],
	resources = [ 'python3' ],
)

Target(
	name = 'nextpnr-gowin',
	sources = [ 'nextpnr' ],
	dependencies = [ 'python3', 'nextpnr-bba', 'apicula-bba'],
	resources = [ 'python3' ],
	package = 'gowin',
)

# architecture specific
SourceLocation(
	name = 'icestorm',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/icestorm',
	revision = 'origin/master',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'prjtrellis',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/prjtrellis',
	revision = 'origin/master',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'prjoxide',
	vcs = 'git',
	location = 'https://github.com/gatecat/prjoxide',
	revision = 'origin/master',
	license_file = 'COPYING',
)

SourceLocation(
	name = 'mistral',
	vcs = 'git',
	location = 'https://github.com/Ravenslofty/mistral',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'apicula',
	vcs = 'git',
	location = 'https://github.com/YosysHQ/apicula',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'icestorm',
	sources = [ 'icestorm' ],
	package = 'ice40',
)

Target(
	name = 'prjtrellis',
	sources = [ 'prjtrellis' ],
	package = 'ecp5',
)

Target(
	name = 'prjoxide',
	sources = [ 'prjoxide' ],
	package = 'nexus',
)

Target(
	name = 'apicula',
	sources = [ 'apicula' ],
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
	package = 'gowin',
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64', 'darwin-x64', 'darwin-arm64' ],
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

Target(
	name = 'apicula-bba',
	sources = [ 'nextpnr' ],
	dependencies = [ 'apicula', 'python3' ],
	resources = [ 'python3' ],
	gitrev = [ ('nextpnr', 'gowin') ],
	build_native = True,
)
