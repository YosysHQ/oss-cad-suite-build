# -*- coding: utf-8 -*-
"""Repo package for libvcs."""
from __future__ import absolute_import, print_function, unicode_literals

import logging

from .base import BaseRepo, RepoLoggingAdapter
from .git import GitRepo
from .hg import MercurialRepo
from .svn import SubversionRepo

__all__ = [
    'GitRepo',
    'MercurialRepo',
    'SubversionRepo',
    'BaseRepo',
    'RepoLoggingAdapter',
]

logger = logging.getLogger(__name__)
