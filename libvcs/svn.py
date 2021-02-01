#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Subversion object for libvcs.

The follow are from saltstack/salt (Apache license):

- [`SubversionRepo.get_revision_file`](libvcs.svn.SubversionRepo.get_revision_file)

The following are pypa/pip (MIT license):

- [`SubversionRepo.get_url_and_revision_from_pip_url`](libvcs.svn.SubversionRepo.get_url_and_revision_from_pip_url)
- [`SubversionRepo.get_url`](libvcs.svn.SubversionRepo.get_url)
- [`SubversionRepo.get_revision`](libvcs.svn.SubversionRepo.get_revision)
- [`get_rev_options`](libvcs.svn.get_rev_options)
"""  # NOQA: E5
from __future__ import absolute_import, print_function, unicode_literals

import logging
import os
import re

from ._compat import urlparse
from .base import BaseRepo

logger = logging.getLogger(__name__)


class SubversionRepo(BaseRepo):
    bin_name = 'svn'
    schemes = ('svn', 'svn+ssh', 'svn+http', 'svn+https', 'svn+svn')

    def __init__(self, url, **kwargs):
        """A svn repository.

        Parameters
        ----------
        url : str
            URL in subversion repository

        svn_username : str, optional
            username to use for checkout and update

        svn_password : str, optional
            password to use for checkout and update

        svn_trust_cert : bool
            trust the Subversion server site certificate, default False
        """
        if 'svn_trust_cert' not in kwargs:
            self.svn_trust_cert = False

        self.rev = kwargs.get('rev')
        BaseRepo.__init__(self, url, **kwargs)

    def _user_pw_args(self):
        args = []
        for param_name in ['svn_username', 'svn_password']:
            if hasattr(self, param_name):
                args.extend(['--' + param_name[4:], getattr(self, param_name)])
        return args

    def obtain(self, quiet=None):
        self.check_destination()

        url, rev = self.url, self.rev

        cmd = ['checkout', '-q', url, '--non-interactive']
        if self.svn_trust_cert:
            cmd.append('--trust-server-cert')
        cmd.extend(self._user_pw_args())
        cmd.extend(get_rev_options(url, rev))
        cmd.append(self.path)

        self.run(cmd)

    def get_revision_file(self, location):
        """Return revision for a file."""

        current_rev = self.run(['info', location])

        _INI_RE = re.compile(r"^([^:]+):\s+(\S.*)$", re.M)

        info_list = _INI_RE.findall(current_rev)
        return int(dict(info_list)['Revision'])

    def get_revision(self, location=None):
        try:
            ret = self.run(['info', '--show-item', 'revision'])
            return ret.strip()
        except exc.LibVCSException:
            return None

    @classmethod
    def get_url_and_revision_from_pip_url(cls, pip_url):
        # hotfix the URL scheme after removing svn+ from svn+ssh:// re-add it
        url, rev = super(SubversionRepo, cls).get_url_and_revision_from_pip_url(pip_url)
        if url.startswith('ssh://'):
            url = 'svn+' + url
        return url, rev

    def update_repo(self, dest=None):
        self.check_destination()
        if os.path.isdir(os.path.join(self.path, '.svn')):
            dest = self.path if not dest else dest

            url, rev = self.url, self.rev

            cmd = ['update']
            cmd.extend(self._user_pw_args())
            cmd.extend(get_rev_options(url, rev))

            self.run(cmd)
        else:
            self.obtain()
            self.update_repo()

    def get_remote(self):
        try:
            ret = self.run(['info', '--show-item', 'url'])
            return ret.strip()
        except exc.LibVCSException:
            return None

    def checkout(self, revision):
        self.run(['up', '-r'+revision])
        self.run(['revert', '--recursive', '.'])

def get_rev_options(url, rev):
    """Return revision options. From pip pip.vcs.subversion."""
    if rev:
        rev_options = ['-r', rev]
    else:
        rev_options = []

    r = urlparse.urlsplit(url)
    if hasattr(r, 'username'):
        # >= Python-2.5
        username, password = r.username, r.password
    else:
        netloc = r[1]
        if '@' in netloc:
            auth = netloc.split('@')[0]
            if ':' in auth:
                username, password = auth.split(':', 1)
            else:
                username, password = auth, None
        else:
            username, password = None, None

    if username:
        rev_options += ['--username', username]
    if password:
        rev_options += ['--password', password]
    return rev_options
