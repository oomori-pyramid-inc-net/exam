#!/bin/bash
set -eu

usage_exit() {
  echo "Usage: basic_auth.sh [-u] [-p]" 1>&2
  exit 1
}

BASIC_AUTH_USER=""
BASIC_AUTH_PASS=""
while getopts "u:p:h" opt; 
do
  case "$opt" in
    u) BASIC_AUTH_USER="${OPTARG}" ;;
    p) BASIC_AUTH_PASS="${OPTARG}" ;;
    h)  usage_exit ;;
    \?) usage_exit ;;
  esac
done

HTPASSWD_FILE="/etc/httpd/passwd/.htpasswd"
BASIC_AUTH_FILE="/etc/httpd/conf.d/basic_auth.conf"
mkdir -p /etc/httpd/passwd/
if [ "$BASIC_AUTH_USER" != "" ] && [ "$BASIC_AUTH_PASS" != "" ]; then
  htpasswd -c -b "$HTPASSWD_FILE" "$BASIC_AUTH_USER" "$BASIC_AUTH_PASS"
  cp /vagrant/conf.d/httpd/basic_auth.conf "$BASIC_AUTH_FILE"
  echo "Enable BasicAuth!"
else
  : > "$BASIC_AUTH_FILE"
  : > "$HTPASSWD_FILE"
  echo "Disable BasicAuth!"
fi
