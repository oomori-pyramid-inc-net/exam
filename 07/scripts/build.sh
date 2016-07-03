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

docker build -t docker_nginx /vagrant/docker/nginx
docker build -t docker_wordpress /vagrant/docker/wordpress
docker build -t docker_mysql /vagrant/docker/mysql

WORK_CONTAINER=import_ddl
trap 'docker rm -f ${WORK_CONTAINER} ; exit 1'  1 2 3 15 ERR
## mysql_inistall_db
docker run \
  --rm --name ${WORK_CONTAINER} \
  -v /var/docker/mysql/var/lib/mysql:/var/lib/mysql:rw \
  -v /var/docker/mysql/var/log/mysql:/var/log/mysql:rw \
  -v /var/docker/mysql/var/backups/mysql:/var/backups/mysql:rw \
  docker_mysql install
## DDL投入
docker run \
  -d --name ${WORK_CONTAINER} \
  -v /var/docker/mysql/var/lib/mysql:/var/lib/mysql:rw \
  -v /var/docker/mysql/var/log/mysql:/var/log/mysql:rw \
  -v /var/docker/mysql/var/backups/mysql:/var/backups/mysql:rw \
  docker_mysql
until docker exec import_ddl mysqladmin -uroot ping 2> /dev/null
do
	echo "waiting for mysqld boot ..."
  sleep 1
done
docker exec -i ${WORK_CONTAINER} mysql -uroot < /vagrant/files/wordpress.ddl
docker stop ${WORK_CONTAINER}
docker rm ${WORK_CONTAINER}
