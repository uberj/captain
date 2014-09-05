#!/bin/bash

# XXX This is a total hack. We need to have apache do this be default
grep '. /etc/environment' /etc/apache2/envvars

if [ $? -eq 1 ]; then
    echo '. /etc/environment' >> /etc/apache2/envvars
fi

SCRIPT_DIR=$(dirname $0)
pushd $SCRIPT_DIR
    cp captain/settings/local.py-heat captain/settings/local.py
    source /etc/environment
    echo 'yes' | python manage.py collectstatic
    echo 'no' | python manage.py syncdb --migrate
popd

service apache2 restart