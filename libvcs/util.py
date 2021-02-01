# -*- coding: utf-8 -*-
"""Utility functions for libvcs."""
from __future__ import absolute_import, print_function, unicode_literals

import datetime
import errno
import logging
import os
import subprocess

from . import exc
from ._compat import console_to_str

logger = logging.getLogger(__name__)


def which(
    exe=None, default_paths=['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin']
):
    """Return path of bin. Python clone of /usr/bin/which.

    from salt.util - https://www.github.com/saltstack/salt - license apache

    Parameters
    ----------
    exe : str
        Application to search PATHs for.
    default_path : list
        Application to search PATHs for.

    Returns
    -------
    str :
        Path to binary
    """

    def _is_executable_file_or_link(exe):
        # check for os.X_OK doesn't suffice because directory may executable
        return os.access(exe, os.X_OK) and (os.path.isfile(exe) or os.path.islink(exe))

    if _is_executable_file_or_link(exe):
        # executable in cwd or fullpath
        return exe

    # Enhance POSIX path for the reliability at some environments, when
    # $PATH is changing. This also keeps order, where 'first came, first
    # win' for cases to find optional alternatives
    search_path = (
        os.environ.get('PATH') and os.environ['PATH'].split(os.pathsep) or list()
    )
    for default_path in default_paths:
        if default_path not in search_path:
            search_path.append(default_path)
    os.environ['PATH'] = os.pathsep.join(search_path)
    for path in search_path:
        full_path = os.path.join(path, exe)
        if _is_executable_file_or_link(full_path):
            return full_path
    logger.info(
        '\'{0}\' could not be found in the following search path: '
        '\'{1}\''.format(exe, search_path)
    )

    return None


def mkdir_p(path):
    """Make directories recursively.

    Parameters
    ----------
    path : str
        path to create
    """
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise Exception('Could not create directory %s' % path)


class RepoLoggingAdapter(logging.LoggerAdapter):

    """Adapter for adding Repo related content to logger.

    Extends `logging.LoggerAdapter`'s functionality.

    The standard library :py:mod:`logging` facility is pretty complex, so this
    warrants and explanation of what's happening.

    Any class that subclasses this will have its class attributes for:

    - :attr:`~.bin_name` -> ``repo_vcs``
    - :attr:`~.repo_name` -> ``repo_name``

    Added to a dictionary of context information in :py:meth:`
    logging.LoggerAdapter.process()` to be made use of when the user of this
    library wishes to use a custom :class:`logging.Formatter` to output
    results.
    """

    def __init__(self, *args, **kwargs):
        logging.LoggerAdapter.__init__(self, *args, **kwargs)

    def process(self, msg, kwargs):
        """Add additional context information for loggers."""
        prefixed_dict = {}
        prefixed_dict['repo_vcs'] = self.bin_name
        prefixed_dict['repo_name'] = self.repo_name

        kwargs["extra"] = prefixed_dict

        return msg, kwargs


def run(
    cmd,
    shell=False,
    cwd=None,
    log_in_real_time=True,
    check_returncode=True,
    callback=None,
):
    """Run 'cmd' in a shell and return the combined contents of stdout and
    stderr (Blocking).  Throws an exception if the command exits non-zero.

    Parameters
    ----------
    cmd : list or str, or single str, if shell=True
       the command to run

    shell : boolean
        boolean indicating whether we are using advanced shell
        features. Use only when absolutely necessary, since this allows a lot
        more freedom which could be exploited by malicious code. See the
        warning here:
        http://docs.python.org/library/subprocess.html#popen-constructor

    cwd : str
        dir command is run from. Defaults to ``path``.

    log_in_real_time : boolean
        boolean indicating whether to read stdout from the
        subprocess in real time instead of when the process finishes.

    check_returncode : bool
        Indicate whether a `libvcs.exc.CommandError` should be raised if return code is
        different from 0.

    callback : callable
        callback to return output as a command executes, accepts a function signature
        of `(output, timestamp)`. Example usage::

            def progress_cb(output, timestamp):
                sys.stdout.write(output)
                sys.stdout.flush()
            run(['git', 'pull'], callback=progrses_cb)
    """
    proc = subprocess.Popen(
        cmd,
        shell=shell,
        stderr=subprocess.PIPE,
        stdout=subprocess.PIPE,
        cwd=cwd,
    )

    all_output = []
    code = None
    line = None
    while code is None:
        code = proc.poll()

        # output = console_to_str(proc.stdout.readline())
        # all_output.append(output)
        if callback and callable(callback):
            line = console_to_str(proc.stderr.read(128))
            if line:
                callback(output=line, timestamp=datetime.datetime.now())
    if callback and callable(callback):
        callback(output='\r', timestamp=datetime.datetime.now())

    lines = filter(None, (line.strip() for line in proc.stdout.readlines()))
    all_output = console_to_str(b'\n'.join(lines))
    if code:
        stderr_lines = filter(None, (line.strip() for line in proc.stderr.readlines()))
        all_output = console_to_str(b''.join(stderr_lines))
    output = ''.join(all_output)
    if code != 0 and check_returncode:
        raise exc.CommandError(output=output, returncode=code, cmd=cmd)
    return output
