# mysql2git

by Remi Plourde

<http://github.com/remino/mysql2git>

Dump schema and data of each table in selected or all databases of a MySQL host into a Git repo.

## Installation

It's a shell script for Bash. Just make sure MySQL and Git are installed.

## Configuration

It's recommended to set username and password in ````~/.my.cnf```` to avoid typing your credentials every time this script launches any MySQL binary:

    [client]
    user=mysql_username
    password=mysql_password

## Usage

    Usage: mysql2git.sh [options] dump-dir [db1 db2...]

      options:
        -u username -p password -h host
          MySQL username, password, and host.
        -m message
          Git commit message.

## Links

Information related to storing MySQL dump files into a Git repo:

* <http://www.viget.com/extend/backup-your-database-in-git/>
* <http://www.linuxjournal.com/node/1001956>
