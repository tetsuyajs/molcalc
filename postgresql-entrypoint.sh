#!/bin/bash

# chown $POSTGRES_USER:$POSTGRES_USER $PGDATA

#$POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -U $POSTGRES_USER --no-locale
$POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -U $POSTGRES_USER

echo "host all all 0.0.0.0/0 trust" >> $PGDATA/pg_hba.conf

\pg_ctl -D "$PGDATA" \
			-o "-c listen_addresses='localhost'" \
			-w start

: ${POSTGRES_USER:=postgres}
: ${POSTGRES_DB:=$POSTGRES_USER}
export POSTGRES_USER POSTGRES_DB

psql=( psql -v ON_ERROR_STOP=1 )

if [ "$POSTGRES_DB" != 'postgres' ]; then
	"${psql[@]}" --username postgres <<-EOSQL
		CREATE DATABASE "$POSTGRES_DB" ;
	EOSQL
	echo
fi

if [ "$POSTGRES_USER" = 'postgres' ]; then
	op='ALTER'
else
	op='CREATE'
fi

"${psql[@]}" --username postgres <<-EOSQL
	$op USER "$POSTGRES_USER" WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD' ;
EOSQL
echo

pg_ctl -D "$PGDATA" -m fast -w stop

cp -f /tmp/postgresql.conf $PGDATA
cp -f /tmp/pg_hba.conf $PGDATA

postgres

#su $POSTGRES_USER
#set -e
# $POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -W -U $POSTGRES_USER --no-locale
# $POSTGRES_HOME/bin/postgres
#docker rm postgres | docker build -t molcalc/postgresql:0.1 -f postgresql-dockerfile . | docker run -d --name postgres -p 5433:5432 -v C:/Users/Jingring/git/molcalc/volumes/pgdata:/usr/local/pgsql/data molcalc/postgresql:0.1 | docker ps -a
# $POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -W -U $POSTGRES_USER --no-locale
