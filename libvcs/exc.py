# -*- coding: utf-8 -*-
"""Exceptions for libvcs.

If you see this, we're publishing to S3 automatically

"""
from __future__ import absolute_import, print_function, unicode_literals


class LibVCSException(Exception):
    """Standard exception raised by libvcs."""

    pass


class CommandError(LibVCSException):
    """This exception is raised on non-zero return codes."""

    def __init__(self, output, returncode=None, cmd=None):
        self.returncode = returncode
        self.output = output
        if cmd:
            if isinstance(cmd, list):
                cmd = ' '.join(cmd)
            self.cmd = cmd

    def __str__(self):
        message = self.message.format(returncode=self.returncode, cmd=self.cmd)
        if len(self.output.strip()):
            message += '\n%s' % self.output
        return message

    message = 'Command failed with code {returncode}: {cmd}'


class CommandTimeoutError(CommandError):
    """CommandError which gets raised when a subprocess exceeds its timeout."""

    pass


class InvalidPipURL(LibVCSException):
    """Invalid pip-style URL."""

    def __init__(self, url):
        self.url = url
        super(InvalidPipURL, self).__init__()

    def __str__(self):
        return self.message

    message = (
        'Repo URL %s requires a vcs scheme. Prepend the vcs (hg+, git+, svn+)'
        'to the repo URL. e.g: git+https://github.com/freebsd/freebsd.git'
    )


class InvalidVCS(LibVCSException):
    """Invalid VCS."""

    pass
