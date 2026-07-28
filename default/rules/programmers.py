from src.base import SourceLocation, Target

# openfpgaloader

SourceLocation(
	name = 'openfpgaloader',
	vcs = 'git',
	location = 'https://github.com/trabucayre/openFPGALoader',
	revision = 'origin/master',
	license_file = 'LICENSE',
)

Target(
	name = 'openfpgaloader',
	sources = [ 'openfpgaloader' ],
	package = 'programmers',
)

