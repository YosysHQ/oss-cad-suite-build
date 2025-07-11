from src.base import SourceLocation, Target

SourceLocation(
	name = 'gtkwave',
	vcs = 'git',
	location = 'https://github.com/gtkwave/gtkwave',
	revision = '10cfae614ed8be80b5bb64e8c2194e7dffcd297a',
	license_file = 'LICENSE',
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
)
