#!/bin/bash

# mysql2git
# by Remi Plourde
# http://github.com/remino/mysql2git

mysql2git_main() {
  [ $# -lt 1 ] && mysql2git_usage

  GITCIMSG=""
  MYSQLARGS=""

  while getopts 'u:p:h:m:' opt; do
    case $opt in
      u) MYSQLARGS="$MYSQLARGS -u $OPTARG";;
      p) MYSQLARGS="$MYSQLARGS -p$OPTARG";;
      h) MYSQLARGS="$MYSQLARGS -h $OPTARG";;
      m) GITCIMSG="$OPTARG";;
      ?) mysql2git_usage;;
    esac
  done
  shift $(( OPTIND-1 ))

  DUMPDIR=$1
  [ ! -d "$DUMPDIR" ] && mkdir "$DUMPDIR"
  cd "$DUMPDIR"

  [ ! -e ".git" ] && git init .

  shift
  if [ $# -lt 1 ]; then
    DBLIST=`echo show databases | mysql --vertical=false | tail -n +2`
  else
    DBLIST="$@"
  fi

  set +o noclobber
  for db in $DBLIST; do
    DBDIR="$db"
    TABLELIST=`echo show tables | mysql -D $db --vertical=false | tail -n +2`
    [ -d $DBDIR ] && rm -fr $DBDIR
    mkdir -p $DBDIR
    for table in $TABLELIST; do
      tabledir="$DBDIR/$table"
      mkdir -p "$tabledir"
      mysqldump --skip-extended-insert --skip-dump-date --no-data \
        $db $table > "$tabledir/schema.sql"
      mysqldump --skip-extended-insert --skip-dump-date --no-create-info \
        $db $table > "$tabledir/data.sql"
    done
  done

  git add .

  GITRMFILES="$( git ls-files --deleted )"
  if [ "$GITRMFILES" != "" ]; then
    git rm $GITRMFILES
  fi

  if [ "$GITCIMSG" == "" ]; then
    git commit
  else
    git commit -m "$GITCIMSG"
  fi
}

mysql2git_usage() {
  echo "Usage: `basename $0` [options] dump-dir [db1 db2...]"
  echo ""
  echo "  options:"
  echo "    -u username -p password -h host"
  echo "      MySQL username, password, and host."
  echo "    -m message"
  echo "      Git commit message."
  exit 1
}

mysql2git_main $@
