FROM gliderlabs/alpine:3.3

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apk-install openssl \
	&& wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
	&& tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
	&& rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
	&& mv entrykit /bin/entrykit \
	&& chmod +x /bin/entrykit \
	&& entrykit --symlink

# MariaDB server and client
#RUN apk update && apk add mariadb mariadb-client
RUN apk-install mysql mysql-client

# make life easier
ENV TERM xterm

# import files into container
COPY my.cnf /etc/mysql/my.cnf

## other applications need to backup/analyze data and logs
VOLUME /var/lib/mysql
VOLUME /var/log/mysql

# create and make available a directory for backups
RUN mkdir -p /var/backups/mysql
RUN chmod a+r /var/backups/mysql/
VOLUME /var/backups/mysql

# MariaDB port
EXPOSE 3306

COPY install.sh /install.sh

ENTRYPOINT [ \
  "switch", \
    "shell=/bin/sh", \
    "install=/install.sh", "--", \
  "prehook", \
    "chown -R mysql:mysql /var/log/mysql", \
    "chown -R mysql:mysql /var/lib/mysql", "--", \
  "mysqld_safe" \
]
