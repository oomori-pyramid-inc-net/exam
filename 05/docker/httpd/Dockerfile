FROM httpd:2.4.20

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apt-get update && apt-get install -y wget \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

ENV HTTPDCONF_DIR /usr/local/apache2/conf
RUN apt-get update && apt-get install patch
COPY httpd.conf.patch /tmp/httpd.conf.patch
RUN patch -ub -B /tmp -o $HTTPDCONF_DIR/httpd.conf.tmpl $HTTPDCONF_DIR/httpd.conf /tmp/httpd.conf.patch

COPY run.sh /run.sh
ENTRYPOINT [ \
  "switch", "shell=/bin/bash", "--", \
  "render", "$HTTPDCONF_DIR/httpd.conf", "--", \
  "sh", "/run.sh" \
]
