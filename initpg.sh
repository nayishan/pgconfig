#!/bin/bash
databasemode=$1
if [ -z $databasemode ];then
    initdb -D $PGDATA -E UTF8 --locale=C -U $PGUSER -W -m ${databasemode}
else
    initdb -D $PGDATA -E UTF8 --locale=C -U $PGUSER -W
fi
