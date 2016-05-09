#!/bin/bash
set -eu

yum -y update
yum -y install httpd ntp
curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

sed -i -e "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#EnableMMAP off/EnableMMAP off/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#EnableSendfile off/EnableSendfile off/g" /etc/httpd/conf/httpd.conf
sed -i -e '/Options/s/ Indexes / -Indexes /g' /etc/httpd/conf/httpd.conf


# td-agent用の設定がなければ追加する
COMMENT="# For td-agent"
CONF_PATH="/etc/sysctl.conf"
if ! grep -q "$COMMENT" "$CONF_PATH"; then
cat << EOS >> "$CONF_PATH"

$COMMENT
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10240    65535
EOS
	sysctl -w
fi

# config.d/*.confを読み込むようにする
CONF_PATH="/etc/td-agent/td-agent.conf"
CONFIGD_PATH="/etc/td-agent/config.d"
COMMENT="# Load config files from the config directory \"$CONFIGD_PATH\"."
mkdir -p "$CONFIGD_PATH"
if ! grep -q "$COMMENT" "$CONF_PATH"; then
cat << EOS >> "$CONF_PATH"

$COMMENT
@include $CONFIGD_PATH/*.conf
EOS
fi
cp /vagrant/conf/td-agent/apache.conf /etc/td-agent/config.d/apache.conf

# ログの読み書き用に権限変更
chmod +rx /var/log/httpd
chmod 777 /var/www/html/logs
