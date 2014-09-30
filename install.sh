#!/bin/bash

# XXX This is a total hack. We need to have apache do this be default
grep '. /etc/environment' /etc/apache2/envvars

if [ $? -eq 1 ]; then
    echo '. /etc/environment' >> /etc/apache2/envvars
fi

echo "`date` app install running" > /tmp/dupe_check

SCRIPT_DIR=$(dirname $0)
pushd $SCRIPT_DIR
    set -x
    cp captain/settings/local.py-heat captain/settings/local.py
    source /etc/environment
    echo "`date` Collecting static configs"
    echo 'yes' | python manage.py collectstatic
    echo "`date` Attempting to create table lock"
    echo 'CREATE TABLE create_lock(l int);' | python manage.py dbshell
    if [ $? -eq 0 ]; then
        echo "`date` Lock created"
        echo "Creating tables" > /tmp/i_am_master
        echo 'no' | python manage.py syncdb --migrate
        echo 'DROP TABLE create_lock;' | python manage.py dbshell
    else
        echo "`date` Lock already created..."
        # We need to wait for the machine that is creating the tables to finish their job
        while [[ 1 ]]; do
            wait_time=$[ ( $RANDOM % 10 )  + 1 ]s
            echo "Waiting $wait_time seconds..."
            sleep $wait_time

            echo "SELECT count(1) FROM create_lock;" | python manage.py dbshell
            if [ $? -eq 1 ]; then
                # Looks like the table doesn't exist anymore. Cary on.
                echo "`date` Tables exist!"
                break
            fi
            echo "`date` Tables don't exist yet!"
        done
    fi
    echo "`date` Done with app install logic."
popd

service apache2 restart
