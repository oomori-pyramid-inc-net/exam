FROM nginx:1.8.1-alpine

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apk add --no-cache --update openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

COPY default.conf.tmpl /etc/nginx/conf.d/default.conf.tmpl

COPY run.sh /run.sh
ENTRYPOINT [ \
  "switch", "shell=/bin/sh", "--", \
  "render", "/etc/nginx/conf.d/default.conf", "--", \
  "sh", "/run.sh" \
]
