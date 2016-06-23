#!/bin/bash
set -eu

tee /etc/apt/sources.list.d/docker.list <<-'EOF'
deb https://apt.dockerproject.org/repo ubuntu-trusty main
EOF

apt-get -y update
apt-get -y install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

apt-get -y update
apt-get -y install linux-image-extra-$(uname -r)
apt-get -y install docker-engine
usermod -aG docker vagrant

curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
