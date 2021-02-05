from src.base import SourceLocation, Target

SourceLocation(
	name = 'iverilog',
	vcs = 'git',
	location = 'https://github.com/steveicarus/iverilog',
	revision = 'tags/v11_0',
)

Target(
	name = 'iverilog',
	sources = [ 'iverilog' ],
	license_file = 'iverilog/COPYING',
)
