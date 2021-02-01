# -*- coding: utf-8 -*-
"""Git Repo object for libvcs.

From https://github.com/saltstack/salt (Apache License):

- [`GitRepo.remote`](libvcs.git.GitRepo.remote) (renamed to ``remote``)
- [`GitRepo.remote`](libvcs.git.GitRepo.remote_set) (renamed to ``set_remote``)

From pip (MIT Licnese):

- [`GitRepo.remote`](libvcs.git.GitRepo.remote_set) (renamed to ``set_remote``)
- [`GitRepo.get_url_and_revision_from_pip_url`](libvcs.git.GitRepo.get_url_and_revision_from_pip_url`) (``get_url_rev``)
- [`GitRepo.get_revision`](libvcs.git.GitRepo.get_revision)
- [`GitRepo.get_git_version`](libvcs.git.GitRepo.get_git_version)
"""  # NOQA: E501
from __future__ import absolute_import, print_function, unicode_literals

import collections
import logging
import os
import re

from . import exc
from ._compat import urlparse
from .base import BaseRepo

logger = logging.getLogger(__name__)

GitRemote = collections.namedtuple('GitRemote', ['name', 'fetch_url', 'push_url'])
"""Structure containing git repo information.

Supports `collections.namedtuple._asdict()`
"""


def extract_status(value):
    """Returns ``git status -sb --porcelain=2`` extracted to a dict

    Returns
    -------
    dict
        Dictionary of git repo's status
    """
    pattern = re.compile(
        r"""[\n\r]?
        (
            #
            \W+
            branch.oid\W+
            (?P<branch_oid>
                [a-f0-9]{40}
            )
        )?
        (
            #
            \W+
            branch.head
            [\W]+
            (?P<branch_head>
                .*
            )
            
        )?
        (
            #
            \W+
            branch.upstream
            [\W]+
            (?P<branch_upstream>
                .*
            )
        )?
        (
            #
            \W+
            branch.ab
            [\W]+
            (?P<branch_ab>
                \+(?P<branch_ahead>\d+)
                \W{1}
                \-(?P<branch_behind>\d+)
            )
        )?
        """,
        re.VERBOSE | re.MULTILINE,
    )
    matches = pattern.search(value)
    return matches.groupdict()


class GitRepo(BaseRepo):
    bin_name = 'git'
    schemes = ('git', 'git+http', 'git+https', 'git+ssh', 'git+git', 'git+file')

    def __init__(self, url, **kwargs):
        """A git repository.

        Parameters
        ----------
        url : str
            URL of repo

        tls_verify : bool
            Should certificate for https be checked (default False)
        """
        if 'git_shallow' not in kwargs:
            self.git_shallow = False
        if 'git_submodules' not in kwargs:
            self.git_submodules = []
        if 'tls_verify' not in kwargs:
            self.tls_verify = False

        BaseRepo.__init__(self, url, **kwargs)

    def get_revision(self):
        """Return current revision. Initial repositories return 'initial'."""
        try:
            return self.run(['rev-parse', '--verify', 'HEAD'])
        except exc.CommandError:
            return 'initial'

    @classmethod
    def get_url_and_revision_from_pip_url(cls, pip_url):
        """
        Prefixes stub URLs like 'user@hostname:user/repo.git' with 'ssh://'.
        That's required because although they use SSH they sometimes doesn't
        work with a ssh:// scheme (e.g. Github). But we need a scheme for
        parsing. Hence we remove it again afterwards and return it as a stub.
        The manpage for git-clone(1) refers to this as the "scp-like styntax".
        """
        if '://' not in pip_url:
            assert 'file:' not in pip_url
            pip_url = pip_url.replace('git+', 'git+ssh://')
            url, rev = super(GitRepo, cls).get_url_and_revision_from_pip_url(pip_url)
            url = url.replace('ssh://', '')
        elif 'github.com:' in pip_url:
            raise exc.LibVCSException(
                "Repo %s is malformatted, please use the convention %s for"
                "ssh / private GitHub repositories."
                % (pip_url, "git+https://github.com/username/repo.git")
            )
        else:
            url, rev = super(GitRepo, cls).get_url_and_revision_from_pip_url(pip_url)

        return url, rev

    def obtain(self):
        """Retrieve the repository, clone if doesn't exist."""
        self.check_destination()

        url = self.url

        cmd = ['clone', '--progress']
        if self.git_shallow:
            cmd.extend(['--depth', '1'])
        if self.tls_verify:
            cmd.extend(['-c', 'http.sslVerify=false'])
        cmd.extend([url, self.path])

        self.info('Cloning.')
        self.run(cmd, log_in_real_time=True)

        self.info('Initializing submodules.')
        self.run(['submodule', 'init'], log_in_real_time=True)
        cmd = ['submodule', 'update', '--recursive', '--init']
        cmd.extend(self.git_submodules)
        self.run(cmd, log_in_real_time=True)

    def update_repo(self):
        self.check_destination()

        if not os.path.isdir(os.path.join(self.path, '.git')):
            self.obtain()
            self.update_repo()
            return
        try:
            process = self.run(['fetch', 'origin'], log_in_real_time=True)
        except exc.CommandError:
            self.error("Failed to fetch repository '%s'" % url)
            return
        cmd = ['submodule', 'update', '--recursive', '--init']
        cmd.extend(self.git_submodules)
        self.run(cmd, log_in_real_time=True)

    def remotes(self, flat=False):
        """Return remotes like git remote -v.

        Parameters
        ----------
        flat : bool
            Return a dict of ``tuple`` instead of ``dict``, default `False`.

        Returns
        -------
        dict
            dict of git upstream / remote URLs
        """
        remotes = {}

        cmd = self.run(['remote'])
        ret = filter(None, cmd.split('\n'))

        for remote_name in ret:
            remotes[remote_name] = (
                self.remote(remote_name) if flat else self.remote(remote_name)._asdict()
            )
        return remotes

    def remote(self, name, **kwargs):
        """Get the fetch and push URL for a specified remote name.

        Parameters
        ----------
        name : str
            The remote name used to define the fetch and push URL

        Returns
        -------
        [`GitRemote`](libvcs.git.GitRemote)
            Remote name and url in tuple form
        """

        try:
            ret = self.run(['remote', 'show', '-n', name])
            lines = ret.split('\n')
            remote_fetch_url = lines[1].replace('Fetch URL: ', '').strip()
            remote_push_url = lines[2].replace('Push  URL: ', '').strip()
            if remote_fetch_url != name and remote_push_url != name:
                return GitRemote(
                    name=name, fetch_url=remote_fetch_url, push_url=remote_push_url
                )
            else:
                return None
        except exc.LibVCSException:
            return None

    def get_remote(self):
        try:
            ret = self.run(['remote', '-v'])
            lines = ret.split('\n')
            for line in lines:
                parts = line.split()
                if (len(parts)==3):
                    if parts[0]=='origin':
                        return parts[1]
            return None
        except exc.LibVCSException:
            return None

    def checkout(self, revision):
        self.run(['reset', '--hard', revision])
        self.run(['submodule', 'update'])

    def set_remote(self, name, url, overwrite=False):
        """Set remote with name and URL like git remote add.

        Parameters
        ----------
        name : str
            defines the remote name.

        url : str
            defines the remote URL
        """

        url = self.chomp_protocol(url)

        if self.remote(name) and overwrite:
            self.run(['remote', 'set-url', name, url])
        else:
            self.run(['remote', 'add', name, url])
        return self.remote(name=name)

    @staticmethod
    def chomp_protocol(url):
        """Return clean VCS url from RFC-style url

        Parameters
        ----------
        url : str
            PIP-style url

        Returns
        -------
        str
            URL as VCS software would accept it
        """
        if '+' in url:
            url = url.split('+', 1)[1]
        scheme, netloc, path, query, frag = urlparse.urlsplit(url)
        rev = None
        if '@' in path:
            path, rev = path.rsplit('@', 1)
        url = urlparse.urlunsplit((scheme, netloc, path, query, ''))
        if url.startswith('ssh://git@github.com/'):
            url = url.replace('ssh://', 'git+ssh://')
        elif '://' not in url:
            assert 'file:' not in url
            url = url.replace('git+', 'git+ssh://')
            url = url.replace('ssh://', '')
        return url

    def get_git_version(self):
        """Return current version of git binary

        Returns
        -------
        str
            git version
        """
        VERSION_PFX = 'git version '
        version = self.run(['version'])
        if version.startswith(VERSION_PFX):
            version = version[len(VERSION_PFX) :].split()[0]
        else:
            version = ''
        return '.'.join(version.split('.')[:3])

    def status(self):
        """Retrieve status of project in dict format.

        Wraps ``git status --sb --porcelain=2``. Does not include changed files, yet.

        Returns
        -------
        dict
            Status of current checked out repository

        Examples
        --------

        >>> git_repo.status()
        {
            "branch_oid": 'de6185fde0806e5c7754ca05676325a1ea4d6348',
            "branch_head": 'fix-current-remote-name',
            "branch_upstream": 'origin/fix-current-remote-name',
            "branch_ab": '+0 -0',
            "branch_ahead": '0',
            "branch_behind": '0'
        }
        """
        return extract_status(self.run(['status', '-sb', '--porcelain=2']))

    def get_current_remote_name(self):
        """Retrieve name of the remote / upstream of currently checked out branch.

        Returns
        -------
        str
            If upstream the same, returns ``branch_name``.
            If upstream mismatches, returns ``remote_name/branch_name``.
        """
        match = self.status()

        if match['branch_upstream'] is None:  # no upstream set
            return match['branch_head']
        return match['branch_upstream'].replace('/' + match['branch_head'], '')
