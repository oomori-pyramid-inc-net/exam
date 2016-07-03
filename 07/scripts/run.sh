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

IS_DOCKER_RUNNING=$(is_running docker)
if [ "$IS_DOCKER_RUNNING" == 'true' ]; then
  service docker restart
else
  service docker start
fi

if [ $(docker ps -qa | wc -l) -gt 1 ]; then
  docker rm -f $(docker ps -qa)
fi

docker run -d \
  --name docker_mysql_1 \
  -v /var/docker/mysql/var/lib/mysql:/var/lib/mysql:rw \
  -v /var/docker/mysql/var/log/mysql:/var/log/mysql:rw \
  -v /var/docker/mysql/var/backups/mysql:/var/backups/mysql:rw \
  docker_mysql

docker run -d \
  --name docker_wordpress_1 \
  -e LISTEN_PORT=9000 \
  -e DB_HOST=mysql:3306 \
  --link docker_mysql_1:mysql \
  -v /wordpress:/var/www/html:rw \
  docker_wordpress

docker run -d \
  --name docker_nginx_1 \
  -p 80:80 \
  -e LISTEN_PORT=80 \
  -e BACKEND=wordpress:9000 \
  --link docker_wordpress_1:wordpress \
  -v /wordpress:/var/www/html:rw \
  docker_nginx
