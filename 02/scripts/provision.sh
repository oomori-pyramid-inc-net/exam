#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/^Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

sed -i -e "s/#EnableMMAP off/EnableMMAP off/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#EnableSendfile off/EnableSendfile off/g" /etc/httpd/conf/httpd.conf
sed -i -e '/Options/s/ Indexes / -Indexes /g' /etc/httpd/conf/httpd.conf

# リダイレクト設定がなければ追加 
REDIRECT="Redirect permanent /images http://localhost:5001/assets"
CONF_PATH="/etc/httpd/conf/httpd.conf"
if ! grep -q "$REDIRECT" "$CONF_PATH"; then
  sed -i -e "$ a $REDIRECT" "$CONF_PATH"
fi
