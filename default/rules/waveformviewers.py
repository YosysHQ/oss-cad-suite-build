from src.base import SourceLocation, Target

SourceLocation(
	name = 'gtkwave',
	vcs = 'git',
	location = 'https://github.com/gtkwave/gtkwave',
	revision = 'origin/lts',
	license_file = 'gtkwave3-gtk3/LICENSE.TXT',
)

Target(
	name = 'gtkwave',
	sources = [ 'gtkwave' ],
	package = 'gtkwave',
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
