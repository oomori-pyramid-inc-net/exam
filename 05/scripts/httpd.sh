#!/bin/bash
set -eu

# install depend libs
. /vagrant/scripts/lib.sh
install_apr
install_apr_util
install_pcre
install_openssl

# httpd 
_sysconfdir=/etc
_prefix=/etc/httpd
_bindir=/etc/httpd/bin
_sbindir=/etc/httpd/sbin
_mandir=/etc/httpd/man
_libdir=/etc/httpd/lib
_includedir=/etc/httpd/include
contentdir=/etc/httpd/share
apr_prefix=/usr/local/apr
suexec_caller=apache
docroot=/home
_root_localstatedir=/var
_localstatedir=/etc/httpd

if [ ! -d /etc/httpd ]; then
	pushd /usr/local/src
	curl --remote-name http://ftp.tsukuba.wide.ad.jp/software/apache//httpd/httpd-2.4.20.tar.bz2
	tar jxf httpd-2.4.20.tar.bz2 
	
	pushd httpd-2.4.20
	./configure \
		--prefix=${_sysconfdir}/httpd \
		--exec-prefix=${_prefix} \
		--bindir=${_bindir} \
		--sbindir=${_sbindir} \
		--mandir=${_mandir} \
		--libdir=${_libdir} \
		--sysconfdir=${_sysconfdir}/httpd/conf \
		--includedir=${_includedir}/httpd \
		--libexecdir=${_libdir}/httpd/modules \
		--datadir=${contentdir} \
		--with-installbuilddir=${_libdir}/httpd/build \
		--enable-mpms-shared=all \
		--with-apr=${apr_prefix} --with-apr-util=${apr_prefix} \
		--with-pcre=/usr/local \
		--enable-suexec --with-suexec \
		--with-suexec-caller=${suexec_caller} \
		--with-suexec-docroot=${docroot} \
		--with-suexec-logfile=${_root_localstatedir}/log/httpd/suexec.log \
		--with-suexec-bin=${_sbindir}/suexec \
		--with-suexec-uidmin=500 --with-suexec-gidmin=100 \
		--enable-pie \
		--enable-mods-shared=all \
		--enable-ssl --with-ssl=/usr/local/ssl --disable-distcache \
		--enable-tlsv1x-thunks \
		--enable-proxy \
		--enable-cache \
		--enable-disk-cache \
		--enable-cgid --enable-cgi \
		--enable-authn-anon --enable-authn-alias \
		--disable-imagemap  \
		--localstatedir=${_localstatedir}
	make
	make install
	popd
	popd
fi
/usr/sbin/useradd -c "Apache" -u 48 -s /sbin/nologin -r -d ${contentdir} apache 2> /dev/null || :

cp /vagrant/files/httpd.init /etc/init.d/httpd
cp /vagrant/files/mod_proxy_fcgi.conf /etc/httpd/conf/extra/mod_proxy_fcgi.conf
cp /vagrant/files/mod_remoteip.conf /etc/httpd/conf/extra/mod_remoteip.conf

CONF_PATH="/etc/httpd/conf/httpd.conf"
sed -i -e "s/Listen 80$/Listen 9000/g" $CONF_PATH
sed -i -e "s/User daemon$/User apache/g" $CONF_PATH
sed -i -e "s/Group daemon$/User apache/g" $CONF_PATH
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:9000/g" $CONF_PATH
sed -i -e "s/#LoadModule slotmem_shm_module/LoadModule slotmem_shm_module/g" $CONF_PATH
sed -i -e "s/#LoadModule remoteip_module/LoadModule remoteip_module/g" $CONF_PATH
sed -i -e "s/#LoadModule include_module/LoadModule include_module/g" $CONF_PATH
sed -i -e "s/DirectoryIndex index.html$/DirectoryIndex index.html index.php/g" $CONF_PATH
sed -i -e "s|/etc/httpd/share/htdocs|/var/www/html|g" $CONF_PATH # DocumentRoot変更
sed -i -e "s/LogFormat \"%h/LogFormat \"%a/g" $CONF_PATH # mod_remoteipではホスト名が書き換わらないのでログにはIPを記録する

# 外部ファイルのinclude設定がなければ追加する
COMMENT="# Include other conf"
if ! grep -q "$COMMENT" "$CONF_PATH"; then
cat << EOS >> "$CONF_PATH"
$COMMENT
Include conf/extra/mod_proxy_fcgi.conf
Include conf/extra/mod_remoteip.conf

EOS
fi
