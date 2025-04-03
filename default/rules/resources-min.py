from src.base import Target

Target(
	name = 'system-resources-min',
	sources = [ ],
	patches = [ 'fonts.conf.template', 'win-launcher.c', 'environment', 'environment.bat', 'environment.ps1', 'environment_system.ps1', 'start.bat', 'cacert.pem', 'tabbyadm' ],
	tools = {},
)
