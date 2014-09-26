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
    echo 'CREATE TABLE create_lock(l int);' | python manage.py dbshell
    if [ $? -eq 0 ]; then
        echo "Creating tables" > /tmp/foo
        echo 'no' | python manage.py syncdb --migrate
        echo 'DROP TABLE create_lock;' | python manage.py dbshell
    else
        # We need to wait for the machine that is creating the tables to finish their job
        while 1; do
            sleep $[ ( $RANDOM % 10 )  + 1 ]s
            echo "Tables already created"
            echo "SELECT count(1) FROM create_lock;" | python manage.py dbshell
            if [ $? -eq 1 ]; then
                # Looks like the table doesn't exist anymore. Cary on.
                break
            fi
        done
    fi
popd

service apache2 restart
