# These settings override what's in settings/base.py.
from . import base


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
        'OPTIONS': {
            'init_command': 'SET storage_engine=InnoDB',
            'charset': 'utf8',
            'use_unicode': True,
        },
        'TEST_CHARSET': 'utf8',
        'TEST_COLLATION': 'utf8_general_ci',
    }
}

# Recipients of traceback emails and other notifications.
ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)
MANAGERS = ADMINS

# Debugging displays nice error messages, but leaks memory. Set this to False
# on all server instances and True only for development.
DEBUG = TEMPLATE_DEBUG = True

# Is this a development instance? Set this to True on development/master
# instances and False on stage/prod.
DEV = True

# Make this unique, and don't share it with anybody.  It cannot be blank.
SECRET_KEY = 'asdfasdgasdhahrhahha4b4ba4ahh'

# Replace with site protocol, domain, and (optionally) port.
SITE_URL = 'http://localhost:8000'

# Uncomment this if you are running a local dev instance without HTTPS.
SESSION_COOKIE_SECURE = not DEV
