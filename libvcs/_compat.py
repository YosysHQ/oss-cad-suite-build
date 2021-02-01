# flake8: NOQA
import sys

PY2 = sys.version_info[0] == 2

_identity = lambda x: x


if PY2:
    unichr = unichr
    text_type = unicode
    string_types = (str, unicode)
    from urllib import urlretrieve

    iterkeys = lambda d: d.iterkeys()
    itervalues = lambda d: d.itervalues()
    iteritems = lambda d: d.iteritems()

    import ConfigParser as configparser
    import cPickle as pickle
    from cStringIO import StringIO as BytesIO
    from StringIO import StringIO

    cmp = cmp

    input = raw_input
    from string import lower as ascii_lowercase

    import urlparse

    def console_to_str(s):
        return s.decode('utf_8')

    def implements_to_string(cls):
        cls.__unicode__ = cls.__str__
        cls.__str__ = lambda x: x.__unicode__().encode('utf-8')
        return cls


else:
    unichr = chr
    text_type = str
    string_types = (str,)

    iterkeys = lambda d: iter(d.keys())
    itervalues = lambda d: iter(d.values())
    iteritems = lambda d: iter(d.items())

    import configparser
    import pickle
    from io import BytesIO, StringIO

    cmp = lambda a, b: (a > b) - (a < b)

    input = input
    import urllib.parse as urllib
    import urllib.parse as urlparse
    from string import ascii_lowercase
    from urllib.request import urlretrieve

    console_encoding = sys.__stdout__.encoding

    implements_to_string = _identity

    def console_to_str(s):
        """ From pypa/pip project, pip.backwardwardcompat. License MIT. """
        try:
            return s.decode(console_encoding)
        except UnicodeDecodeError:
            return s.decode('utf_8')
        except AttributeError:  # for tests, #13
            return s
