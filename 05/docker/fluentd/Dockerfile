FROM fluent/fluentd:v0.12.24

USER root
ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apk add --no-cache --update openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

USER fluent
RUN gem install fluent-plugin-in_http_healthcheck

RUN mv /fluentd/etc/$FLUENTD_CONF /fluentd/etc/$FLUENTD_CONF.tmpl
ENTRYPOINT [ \
  "switch", "shell=/bin/sh", "--", \
  "render", "/fluentd/etc/$FLUENTD_CONF", "--", \
  "fluentd", "-c", "/fluentd/etc/$FLUENTD_CONF", "-p", "/fluentd/plugins $FLUENTD_OPT" \
]
