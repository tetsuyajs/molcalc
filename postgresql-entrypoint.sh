#!/bin/bash

chown $POSTGRES_USER:$POSTGRES_USER $PGDATA
su $POSTGRES_USER
$POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -U $POSTGRES_USER --no-locale
postgres

#set -e
# $POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -W -U $POSTGRES_USER --no-locale
# $POSTGRES_HOME/bin/postgres
#docker rm postgres | docker build -t molcalc/postgresql:0.1 -f postgresql-dockerfile . | docker run -d --name postgres -p 5433:5432 -v C:/Users/Jingring/git/molcalc/volumes/pgdata:/usr/local/pgsql/data molcalc/postgresql:0.1 | docker ps -a
# $POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -W -U $POSTGRES_USER --no-locale
