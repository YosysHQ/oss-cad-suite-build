from src.base import Target

Target(
	name = 'system',
	sources = [ ],
	patches = [ 'fonts.conf.template', 'win-launcher.c', 'environment' ],
	system = True,
	create_package = False,
)
