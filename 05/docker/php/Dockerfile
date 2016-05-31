FROM php:5.6.21-fpm-alpine

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apk add --no-cache --update openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

COPY zz-docker.conf.tmpl /usr/local/etc/php-fpm.d/zz-docker.conf.tmpl

ENTRYPOINT [ \
  "switch", "shell=/bin/sh", "--", \
  "render", "/usr/local/etc/php-fpm.d/zz-docker.conf", "--", \
  "php-fpm" \
]
