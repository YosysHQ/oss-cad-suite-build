from src.base import Target

Target(
	name = 'system-resources-min',
	sources = [ ],
	patches = [ 'fonts.conf.template', 'win-launcher.c', 'environment', 'environment.bat', 'start.bat', 'cacert.pem', 'tabbyadm' ],
	tools = {},
)
