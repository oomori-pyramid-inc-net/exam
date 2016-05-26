#!/bin/bash
set -eu

yum -y update

sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum -y install docker-engine
getent group docker >/dev/null || groupadd -r docker
usermod -aG docker vagrant

curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
