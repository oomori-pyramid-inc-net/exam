#! /bin/sh
chown -R mysql:mysql /var/log/mysql
chown -R mysql:mysql /var/lib/mysql
mysql_install_db

