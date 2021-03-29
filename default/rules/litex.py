from src.base import SourceLocation, Target

# HDL
SourceLocation(
	name = 'migen',
	vcs = 'git',
	location = 'https://github.com/m-labs/migen',
	revision = 'origin/master',
)

SourceLocation(
	name = 'nmigen',
	vcs = 'git',
	location = 'https://github.com/nmigen/nmigen',
	revision = 'origin/master',
)

# LiteX SoC builder
SourceLocation(
	name = 'pythondata-software-compiler_rt',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-software-compiler_rt',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litex',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litex',
	revision = 'origin/master',
)

# LiteX cores ecosystem
SourceLocation(
	name = 'liteeth',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/liteeth',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litedram',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litedram',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litepcie',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litepcie',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litesata',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litesata',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litesdcard',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litesdcard',
	revision = 'origin/master',
)

SourceLocation(
	name = 'liteiclink',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/liteiclink',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litevideo',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litevideo',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litescope',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litescope',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litejesd204b',
	vcs = 'git',
	location = 'https://github.com/enjoy-digital/litejesd204b',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litespi',
	vcs = 'git',
	location = 'https://github.com/litex-hub/litespi',
	revision = 'origin/master',
)

SourceLocation(
	name = 'litehyperbus',
	vcs = 'git',
	location = 'https://github.com/litex-hub/litehyperbus',
	revision = 'origin/master',
)

# LiteX boards support
SourceLocation(
	name = 'litex-boards',
	vcs = 'git',
	location = 'https://github.com/litex-hub/litex-boards',
	revision = 'origin/master',
)

# Optional LiteX data
SourceLocation(
	name = 'pythondata-misc-tapcfg',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-misc-tapcfg',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-misc-opentitan',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-misc-opentitan',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-lm32',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-lm32',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-mor1kx',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-mor1kx',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-picorv32',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-picorv32',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-serv',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-serv',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-vexriscv',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-vexriscv',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-vexriscv-smp',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-vexriscv-smp',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-rocket',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-rocket',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-minerva',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-minerva',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-microwatt',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-microwatt',
	revision = 'f9807b6de50aab8b264f0bc9a945e42f1a636456',
)

SourceLocation(
	name = 'pythondata-cpu-blackparrot',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-blackparrot',
	revision = 'origin/master',
)

SourceLocation(
	name = 'pythondata-cpu-cv32e40p',
	vcs = 'git',
	location = 'https://github.com/litex-hub/pythondata-cpu-cv32e40p',
	revision = 'origin/master',
)

Target(
	name = 'litex',
	sources = [ 
        # HDL
        'migen', 'nmigen',
        # LiteX SoC builder
        'pythondata-software-compiler_rt','litex',
        # LiteX cores ecosystem
        'liteeth', 'litedram', 'litepcie', 'litesata', 'litesdcard', 'liteiclink', 'litevideo',
        'litescope', 'litejesd204b', 'litespi', 'litehyperbus',
        # LiteX boards support
        'litex-boards',
        # Optional LiteX data
        'pythondata-misc-tapcfg', 'pythondata-misc-opentitan', 'pythondata-cpu-lm32', 'pythondata-cpu-mor1kx', 'pythondata-cpu-picorv32',
        'pythondata-cpu-serv', 'pythondata-cpu-vexriscv',  'pythondata-cpu-vexriscv-smp', 'pythondata-cpu-rocket', 'pythondata-cpu-minerva',
        'pythondata-cpu-microwatt', 'pythondata-cpu-blackparrot', 'pythondata-cpu-cv32e40p'
    ],
	dependencies = [ 'python3' ],
	resources = [ 'python3' ],
    license_file = 'litex/LICENSE',
)

