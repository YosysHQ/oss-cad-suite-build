from src.base import SourceLocation, Target

SourceLocation(
	name = 'surelog',
	vcs = 'git',
	location = 'https://github.com/chipsalliance/Surelog',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

SourceLocation(
	name = 'surelog-plugin',
	vcs = 'git',
	location = 'https://github.com/chipsalliance/yosys-f4pga-plugins',
	revision = 'origin/main',
	license_file = 'LICENSE',
)

Target(
	name = 'capnproto',
	sources = [ 'surelog'],
	gitrev = [ ('surelog', 'third_party/UHDM/third_party/capnproto') ],
	build_native = True,
)

Target(
	name = 'flatbuffers',
	sources = [ 'surelog'],
	gitrev = [ ('surelog', 'third_party/flatbuffers') ],
	build_native = True,
)

Target(
	name = 'surelog',
	sources = [ 'surelog'],
	dependencies = [ 'capnproto', 'flatbuffers'],
)

Target(
	name = 'surelog-data',
	sources = [ ],
	dependencies = [ 'surelog' ],
	build_native = True,
)

Target(
	name = 'surelog-plugin',
	sources = [ 'surelog-plugin' ],
	dependencies = [ 'yosys', 'surelog'],
	gitrev = [ ('surelog-plugin', 'systemverilog-plugin') ],
	arch = [ 'linux-x64', 'linux-arm', 'linux-arm64', 'linux-riscv64', 'darwin-x64', 'darwin-arm64' ],
)
