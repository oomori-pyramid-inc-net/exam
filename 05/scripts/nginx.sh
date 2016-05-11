#!/bin/bash
set -eu

# install depend libs
. /vagrant/scripts/lib.sh
install_pcre
install_zlib
install_openssl

# nginx
_sysconfdir=/etc
_sbindir=/usr/sbin
_localstatedir=/var
nginx_user=nginx
nginx_group=nginx
nginx_home=${_localstatedir}/cache/nginx
if [ ! -d /etc/nginx ]; then
	pushd /usr/local/src
	curl --remote-name http://nginx.org/download/nginx-1.8.1.tar.gz
	tar -xzvf nginx-1.8.1.tar.gz
	
	pushd nginx-1.8.1
	./configure \
		--prefix=${_sysconfdir}/nginx \
		--sbin-path=${_sbindir}/nginx \
		--conf-path=${_sysconfdir}/nginx/nginx.conf \
		--error-log-path=${_localstatedir}/log/nginx/error.log \
		--http-log-path=${_localstatedir}/log/nginx/access.log \
		--pid-path=${_localstatedir}/run/nginx.pid \
		--lock-path=${_localstatedir}/run/nginx.lock \
		--http-client-body-temp-path=${_localstatedir}/cache/nginx/client_temp \
		--http-proxy-temp-path=${_localstatedir}/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=${_localstatedir}/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=${_localstatedir}/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=${_localstatedir}/cache/nginx/scgi_temp \
		--user=${nginx_user} \
		--group=${nginx_group} \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-file-aio \
		--with-ipv6 \
		--with-pcre=/usr/local/src/pcre-8.38 \
		--with-zlib=/usr/local/src/zlib-1.2.8 \
		--with-openssl=/usr/local/src/openssl-1.0.2h
	make
	make install
	popd
	popd
fi
getent group ${nginx_group} >/dev/null || groupadd -r ${nginx_group}
getent passwd ${nginx_user} >/dev/null || \
		useradd -r -g ${nginx_group} -s /sbin/nologin \
		-d ${nginx_home} -c "nginx user"  ${nginx_user}
mkdir -p ${_localstatedir}/cache/nginx

cp /vagrant/files/nginx.conf /etc/nginx/nginx.conf
cp /vagrant/files/nginx.init /etc/init.d/nginx
