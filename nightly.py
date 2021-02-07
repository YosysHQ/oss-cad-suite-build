#!/usr/bin/env python3

import click, signal, os, sys, shutil
from src.base import loadRules, validateRules, pullCode, buildCode, validateTarget, validateArch, cleanBuild, getArchitecture

def force_shutdown(signum, frame):
	if (os.name != 'nt' and signum != signal.SIGPIPE):
		click.secho("\n==> Keyboard interrupt or external termination signal", fg="red", nl=True, bold=True)
	sys.exit(1)

@click.group(help="""FPGA-Nightly Tool Builder\n""", context_settings=dict(help_option_names=["-h", "--help"]), invoke_without_command=True)
@click.pass_context
def cli(ctx):
	ctx.ensure_object(dict)
	if ctx.invoked_subcommand is None:
		click.secho(ctx.get_help())
	pass

@cli.command()
@click.option('--no-update', help='Do not update source files.', is_flag=True)
@click.option('--no-clean', help='Do not clean last build before build.', is_flag=True)
@click.option('--force', help='Force build of specified target.', is_flag=True)
@click.option('--target', default='default', show_default=True, help='Target project to build.')
@click.option('--arch', default=getArchitecture(), show_default=True, help='Build architecture.')
@click.option('--prefix', default='/opt/fpga-nightly', show_default=True, help='Target prefix to build for.')
@click.option('--rules', default='default', show_default=True, help='Comma separated list of rules to use.')
@click.option('--local', help='Preform local build (using machine own installed tools/libs).', is_flag=True)
@click.option('-j', '--nproc', default=os.cpu_count(), show_default=True, help='Number of build process.')
def build(no_update, no_clean, force, target, arch, prefix, rules, local, nproc):
	"""Build tools"""
	for rule in rules.split(","):
		loadRules(rule)
	validateRules()
	validateTarget(target)
	validateArch(arch)
	pullCode(target, arch, no_update)
	buildCode(target, arch, nproc, no_clean, force, prefix, local)

@cli.command()
@click.option('--arch', default=getArchitecture(), show_default=True, help='Build architecture.')
@click.option('--full', help='Remove all architectures and sources as well.', is_flag=True)
def clean(arch, full):
	"""Clean build"""
	cleanBuild(arch, full)

@cli.command()
@click.option('--target', default='default', show_default=True, help='Target project to build.')
@click.option('--arch', default=getArchitecture(), show_default=True, help='Build architecture.')
@click.option('--rules', default='default', show_default=True, help='Comma separated list of rules to use.')
def source(target, arch, rules):
	"""Update sources"""
	for rule in rules.split(","):
		loadRules(rule)
	validateRules()
	validateTarget(target)
	validateArch(arch)
	pullCode(target, arch, False)

if __name__ == '__main__':
	if os.name == "posix":
		signal.signal(signal.SIGHUP, force_shutdown)
		signal.signal(signal.SIGPIPE, force_shutdown)
	signal.signal(signal.SIGINT, force_shutdown)
	signal.signal(signal.SIGTERM, force_shutdown)

	cli(None)
