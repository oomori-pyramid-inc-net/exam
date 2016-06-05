#!/bin/bash
set -eu

function is_running() {
	SERVICE_NAME=$1
	IS_SERVICE_RUNNING=$(service $SERVICE_NAME status | grep "running")
	if [ "$IS_SERVICE_RUNNING" == "" ]; then
		echo 'false'
	else
		echo 'true'
	fi
}

IS_MYSQL_RUNNING=$(is_running mysql)
if [ "$IS_MYSQL_RUNNING" == 'true' ]; then
  service mysql restart
else
  service mysql start
fi

IS_DOCKER_RUNNING=$(is_running docker)
if [ "$IS_DOCKER_RUNNING" == 'true' ]; then
  service docker restart
else
  service docker start
fi

docker-compose -f /vagrant/docker/docker-compose.yml up -d
