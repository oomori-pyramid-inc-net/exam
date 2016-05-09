#!/bin/bash
set -eu

function is_running() {
	SERVICE_NAME=$1
	IS_SERVICE_RUNNING=$(service $SERVICE_NAME status | grep "is running")
	if [ "$IS_SERVICE_RUNNING" == "" ]; then
		echo 'false'
	else
		echo 'true'
	fi
}

IS_NTPD_RUNNING=$(is_running ntpd)
if [ "$IS_NTPD_RUNNING" == 'true' ]; then
  service ntpd restart
else
  service ntpd start
fi

IS_HTTPD_RUNNING=$(is_running httpd)
if [ "$IS_HTTPD_RUNNING" == 'true' ]; then
  service httpd restart
else
  service httpd start
fi

IS_TDAGENT_RUNNING=$(is_running td-agent)
if [ "$IS_TDAGENT_RUNNING" == 'true' ]; then
  service td-agent restart
else
  service td-agent start
fi
