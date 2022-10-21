from src.base import SourceLocation, Target

SourceLocation(
	name = 'capnproto',
	vcs = 'git',
	location = 'https://github.com/capnproto/capnproto',
	revision = '14f24a41b24cf5b92574e9dfba78816e8234a75c',
)

SourceLocation(
	name = 'flatbuffers',
	vcs = 'git',
	location = 'https://github.com/google/flatbuffers',
	revision = '5792623df42e6165a376907bbb8e6090d0946db5',
)

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
	sources = [ 'capnproto'],
	build_native = True,
)

Target(
	name = 'flatbuffers',
	sources = [ 'flatbuffers'],
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
