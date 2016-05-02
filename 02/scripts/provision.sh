#!/bin/bash
set -eu

function is_installed() {
	SERVICE_NAME=$1
	IS_SERVICE_INSTALLED=$(rpm -qa| grep $SERVICE_NAME)
	if [ "$IS_SERVICE_INSTALLED" == "" ]; then
		echo 'false'
	else
		echo 'true'
	fi
}

yum -y update
yum -y install ntp httpd

# 再インストールを試みるとエラーと判定されるためインストール済み判定を行う
IS_REPOSITORY_INSTALLED=$(is_installed nginx-release-centos)
if [ "$IS_REPOSITORY_INSTALLED" == 'false' ]; then
  rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
fi
yum -y install nginx

yum -y install epel-release
yum -y install mod_extract_forwarded 

sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:80/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#EnableMMAP off/EnableMMAP off/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#EnableSendfile off/EnableSendfile off/g" /etc/httpd/conf/httpd.conf
sed -i -e '/Options/s/ Indexes / -Indexes /g' /etc/httpd/conf/httpd.conf

sed -i -e "s/# MEFaccept 1.2.3.4  1.2.3.5/MEFaccept all/g" /etc/httpd/conf.d/mod_extract_forwarded.conf

cp /vagrant/conf.d/nginx/default.conf /etc/nginx/conf.d/default.conf
