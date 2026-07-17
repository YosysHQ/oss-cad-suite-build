from src.base import SourceLocation, Target

SourceLocation(
	name = 'gtkwave',
	vcs = 'git',
	location = 'https://github.com/gtkwave/gtkwave',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'gtkwave',
	sources = [ 'gtkwave' ],
	package = 'gtkwave',
	arch = [ 'linux-x64', 'linux-arm64', 'darwin-x64', 'darwin-arm64', 'windows-x64' ],
)

SourceLocation(
	name = 'surfer',
	vcs = 'git',
	location = 'https://gitlab.com/surfer-project/surfer',
	revision = 'origin/main',
	license_file = 'LICENSE-EUPL-1.2.txt',
)

Target(
	name = 'surfer',
	sources = [ 'surfer' ],
	package = 'surfer',
	arch = [ 'linux-x64' ],
)
