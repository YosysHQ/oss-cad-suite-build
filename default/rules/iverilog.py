from src.base import SourceLocation, Target

SourceLocation(
	name = 'iverilog',
	vcs = 'git',
	location = 'https://github.com/steveicarus/iverilog',
	revision = '192b6aec96fde982e6ddcb28b346d5893aa8e874',
	license_file = 'COPYING',
)

Target(
	name = 'iverilog',
	sources = [ 'iverilog' ],
	package = 'iverilog',
)
