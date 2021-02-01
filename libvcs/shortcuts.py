# -*- coding: utf-8 -*-
"""Shortcuts"""
from __future__ import absolute_import, print_function, unicode_literals

from libvcs import GitRepo, MercurialRepo, SubversionRepo
from libvcs.exc import InvalidPipURL, InvalidVCS


def create_repo(url, vcs, **kwargs):
    r"""Return a object representation of a VCS repository.

    Returns
    -------
    `libvcs.svn.SubversionRepo`, `libvcs.git.GitRepo`, or `libvcs.hg.MercurialRepo`.

    Examples
    --------

    >>> from libvcs.shortcuts import create_repo
    >>>
    >>> r = create_repo(
    ...     url='https://www.github.com/you/myrepo',
    ...     vcs='git',
    ...     repo_dir='/tmp/myrepo'
    ... )

    >>> r.update_repo()
    |myrepo| (git)  Repo directory for myrepo (git) does not exist @ \
        /tmp/myrepo
    |myrepo| (git)  Cloning.
    |myrepo| (git)  git clone https://www.github.com/tony/myrepo \
        /tmp/myrepo
    Cloning into '/tmp/myrepo'...
    Checking connectivity... done.
    |myrepo| (git)  git fetch
    |myrepo| (git)  git pull
    Already up-to-date.
    """
    if vcs == 'git':
        return GitRepo(url, **kwargs)
    elif vcs == 'hg':
        return MercurialRepo(url, **kwargs)
    elif vcs == 'svn':
        return SubversionRepo(url, **kwargs)
    else:
        raise InvalidVCS('VCS %s is not a valid VCS' % vcs)


def create_repo_from_pip_url(pip_url, **kwargs):
    r"""Return a object representation of a VCS repository via pip-style url.

    Returns
    -------
    `libvcs.svn.SubversionRepo`, `libvcs.git.GitRepo`, or `libvcs.hg.MercurialRepo`.

    Examples
    --------

    >>> from libvcs.shortcuts import create_repo_from_pip_url

    >>> r = create_repo_from_pip_url(
    ...         pip_url='git+https://www.github.com/you/myrepo',
    ...         repo_dir='/tmp/myrepo')

    >>> r.update_repo()
    |myrepo| (git)  Repo directory for myrepo (git) does not exist @ \
        /tmp/myrepo
    |myrepo| (git)  Cloning.
    |myrepo| (git)  git clone https://www.github.com/tony/myrepo \
        /tmp/myrepo
    Cloning into '/tmp/myrepo'...
    Checking connectivity... done.
    |myrepo| (git)  git fetch
    |myrepo| (git)  git pull
    Already up-to-date.
    """
    if pip_url.startswith('git+'):
        return GitRepo.from_pip_url(pip_url, **kwargs)
    elif pip_url.startswith('hg+'):
        return MercurialRepo.from_pip_url(pip_url, **kwargs)
    elif pip_url.startswith('svn+'):
        return SubversionRepo.from_pip_url(pip_url, **kwargs)
    else:
        raise InvalidPipURL(pip_url)
