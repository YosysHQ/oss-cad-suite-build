from src.base import Target

Target(
	name = 'system-resources',
	sources = [ ],
	patches = [ 'setup.sh', 'fonts.conf.template', 'win-launcher.c', 'environment' ],
)
