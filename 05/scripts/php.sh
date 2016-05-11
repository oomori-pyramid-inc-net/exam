#!/bin/bash
set -eu

# install depend libs
. /vagrant/scripts/lib.sh
install_libxml2
install_openssl
install_pcre

# php
if [ ! -e /usr/sbin/php-fpm ]; then
	pushd /usr/local/src
	curl -L http://jp2.php.net/get/php-5.6.21.tar.gz/from/this/mirror > ./php-5.6.21.tar.gz
	tar -xzvf php-5.6.21.tar.gz
	
	pushd php-5.6.21
	_lib=/usr/lib64
	_sysconfdir=/etc
	_root_prefix=/usr
	./configure \
		--prefix=/usr \
		--cache-file=../config.cache \
		--with-libdir=${_lib} \
		--sysconfdir=${_sysconfdir} \
		--with-config-file-path=${_sysconfdir} \
		--with-config-file-scan-dir=${_sysconfdir}/php.d \
		--disable-debug \
		--with-pic \
		--disable-rpath \
		--without-pear \
		--without-gdbm \
		--with-openssl-dir=/usr/local/ssl \
		--with-system-ciphers \
		--with-pcre-dir=/usr/local \
		--with-zlib \
		--with-layout=GNU \
		--with-kerberos \
		--with-libxml-dir=/usr/local \
		--with-mhash \
		--enable-fpm
	make
	make install
	popd
	popd
fi

cp /etc/php-fpm.conf.default /etc/php-fpm.conf
cp /vagrant/files/php-fpm.init /etc/init.d/php-fpm

sed -i -e "s/user = nobody$/user = apache/g" /etc/php-fpm.conf
sed -i -e "s/group = nobody$/group = apache/g" /etc/php-fpm.conf
sed -i -e "s|listen = 127.0.0.1:9000$|listen = /var/run/php-fpm/php-fpm.sock|g" /etc/php-fpm.conf
sed -i -e "s/;listen.owner = nobody$/listen.owner = apache/g" /etc/php-fpm.conf
sed -i -e "s/;listen.group = apache$/listen.group = apache/g" /etc/php-fpm.conf
sed -i -e "s/;listen.mode = 0660$/listen.mode = 0660/g" /etc/php-fpm.conf
sed -i -e "s|;pid = run/php-fpm.pid$|pid = /var/run/php-fpm/php-fpm.pid|g" /etc/php-fpm.conf
sed -i -e "s|;error_log = log/php-fpm.log$|error_log = /var/log/php-fpm/error.log|g" /etc/php-fpm.conf
mkdir -p /var/log/php-fpm

