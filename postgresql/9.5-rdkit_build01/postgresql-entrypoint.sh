#!/bin/bash

echo '[entrypoint] PGDATA directory change owner'
chown -R $POSTGRES_USER:$POSTGRES_USER $PGDATA

if [ `ls -a $PGDATA | wc | awk '{print $1}'` == 2 ]; then
    echo '[entrypoint] PGDATA empty and execute initdb'

    su -c "$POSTGRES_HOME/bin/initdb -E UTF8 --locale en_US.UTF-8 -D $PGDATA -U $POSTGRES_USER" - $POSTGRES_USER

    su -c "$POSTGRES_HOME/bin/pg_ctl -D $PGDATA -w start" - $POSTGRES_USER
    psql -U $POSTGRES_USER -w -c "ALTER USER $POSTGRES_USER WITH UNENCRYPTED PASSWORD '$POSTGRES_PASSWORD';"
    su -c "$POSTGRES_HOME/bin/pg_ctl -D $PGDATA -m fast -w stop" - $POSTGRES_USER


    echo '[entrypoint] config file copy PGDATA from tmp directory'
    cp -f /tmp/postgresql.conf $PGDATA
    chown $POSTGRES_USER:$POSTGRES_USER $PGDATA/postgresql.conf
    cp -f /tmp/pg_hba.conf $PGDATA
    chown $POSTGRES_USER:$POSTGRES_USER $PGDATA/pg_hba.conf

fi

echo '[entrypoint] PostgreSQL start'
su -c "$POSTGRES_HOME/bin/postgres -D $PGDATA" - $POSTGRES_USER
