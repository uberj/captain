#!/bin/bash

# XXX This is a total hack. We need to have apache do this be default
grep '. /etc/environment' /etc/apache2/envvars

if [ $? -eq 1 ]; then
    echo '. /etc/environment' >> /etc/apache2/envvars
fi

source /etc/environment

cp captain/settings/local.py-heat captain/settings/local.py
echo 'yes' | python manage.py collectstatic
echo 'no' | python manage.py syncdb --migrate
