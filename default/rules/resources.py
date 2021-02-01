from rules.base import Target

Target(
	name = 'tcltk-resources',
	sources = [ ],
)

Target(
	name = 'gtk-resources',
	sources = [ ],
)

Target(
	name = 'qt5-resources',
	sources = [ ],
)

Target(
	name = 'font-resources',
	sources = [ ],
	patches = [ 'setup.sh', 'fonts.conf.template' ],
)
