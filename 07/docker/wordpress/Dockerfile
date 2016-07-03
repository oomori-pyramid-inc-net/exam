#FROM php:5.6.21-fpm-alpine
FROM gliderlabs/alpine:3.3

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apk add --no-cache --update openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink


RUN apk-install php-fpm php-mysqli
RUN sed -i -e "s/^;include/include/g" /etc/php/php-fpm.conf
RUN sed -i -e "s/^listen/;listen/g" /etc/php/php-fpm.conf
COPY zz-docker.conf.tmpl /usr/etc/fpm.d/zz-docker.conf.tmpl

EXPOSE 9000
ENTRYPOINT [ \
  "switch", "shell=/bin/sh", "--", \
	"render", "/usr/etc/fpm.d//zz-docker.conf", "/var/www/html/wp-config.php", "--", \
	"php-fpm", "-F", "-O" \
]
