from src.base import SourceLocation, Target

SourceLocation(
	name = 'ecpprog',
	vcs = 'git',
	location = 'https://github.com/gregdavill/ecpprog',
	revision = 'origin/master'
)

Target(
	name = 'ecpprog',
	sources = [ 'ecpprog' ],
	license_file = 'ecpprog/COPYING',
)
