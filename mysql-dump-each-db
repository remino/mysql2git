#!/bin/bash

#
# The idea is to dump each MySQL database on localhost in its own file and
# store it into a Git repo.  This script doesn't take care of the later.
#
# It's recommended to set username and password in ~/.my.cnf:
#
# [client]
# user=root
# password=set_password_here
#
# See:
# http://www.viget.com/extend/backup-your-database-in-git/
# http://www.linuxjournal.com/node/1001956
#

if [ $# -lt 1 ]; then
  echo "Usage: `basename $0` dump-dir [db1 db2...]"
  exit 1
fi

DUMPDIR=$1

shift
if [ $# -lt 1 ]; then
  DBLIST=`echo show databases | mysql --vertical=false | tail -n +2`
else
  DBLIST="$@"
fi

set +o noclobber
for db in $DBLIST; do
  DBDIR=$DUMPDIR/$db
  DATADIR=$DBDIR/data
  SCHEMADIR=$DBDIR/schema
  TABLELIST=`echo show tables | mysql -D $db --vertical=false | tail -n +2`
  [ -d $DBDIR ] || mkdir $DBDIR
  [ -d $DATADIR ] || mkdir $DATADIR
  [ -d $SCHEMADIR ] || mkdir $SCHEMADIR
  for table in $TABLELIST; do
    tabledir="$DBDIR/$table"
    mkdir -p "$tabledir"
    mysqldump --skip-extended-insert --skip-dump-date --no-data \
      $db $table > "$tabledir/schema.sql"
    mysqldump --skip-extended-insert --skip-dump-date --no-create-info \
      $db $table > "$tabledir/data.sql"
  done
done