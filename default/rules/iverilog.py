from src.base import SourceLocation, Target

SourceLocation(
	name = 'iverilog',
	vcs = 'git',
	location = 'https://github.com/steveicarus/iverilog',
	revision = 'origin/master',
	license_file = 'COPYING',
)

Target(
	name = 'iverilog',
	sources = [ 'iverilog' ],
	package = 'iverilog',
)
