#!/bin/bash
set -eu

yum -y update
yum -y install httpd

sed -i -e "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

sed -i -e "s/#EnableMMAP off/EnableMMAP off/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#EnableSendfile off/EnableSendfile off/g" /etc/httpd/conf/httpd.conf
sed -i -e '/Options/s/ Indexes / -Indexes /g' /etc/httpd/conf/httpd.conf
