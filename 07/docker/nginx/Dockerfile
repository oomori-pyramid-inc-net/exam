FROM gliderlabs/alpine:3.3

RUN apk-install nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log 
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN apk-install openssl \
	&& wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
	&& tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
	&& rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
	&& mv entrykit /bin/entrykit \
	&& chmod +x /bin/entrykit \
	&& entrykit --symlink

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf.tmpl /etc/nginx/conf.d/default.conf.tmpl

ENTRYPOINT [ \
	"switch", "shell=/bin/sh", "--", \
	"render", "/etc/nginx/conf.d/default.conf", "--", \
	"nginx", "-g", "daemon off;" \
]
