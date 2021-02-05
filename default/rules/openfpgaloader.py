from src.base import SourceLocation, Target

SourceLocation(
	name = 'openfpgaloader',
	vcs = 'git',
	location = 'https://github.com/trabucayre/openFPGALoader',
	revision = 'origin/master',
)

Target(
	name = 'openfpgaloader',
	sources = [ 'openfpgaloader' ],
	license_file = 'openfpgaloader/LICENSE',
)
