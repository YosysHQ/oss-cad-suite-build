from src.base import Target

Target(
	name = 'system-resources',
	sources = [ ],
	patches = [ 'fonts.conf.template', 'win-launcher.c', 'environment', 'environment.fish', 'environment.bat', 'environment.ps1', 'environment_system.ps1', 'start.bat', 'cacert.pem', 'tabbyadm' ],
	tools = {},
)

Target(
	name = 'system-resources-tabby',
	sources = [ ],
	patches = [ 'fonts.conf.template', 'win-launcher.c', 'environment', 'environment.bat', 'environment.ps1', 'environment_system.ps1', 'start.bat', 'cacert.pem', 'tabbyadm' ],
	tools = {},
)
