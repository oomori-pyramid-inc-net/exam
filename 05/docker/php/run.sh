#!/bin/sh
set -eu

: ${FLUENTD_HEALTHCHECK_ENDPOINT:?"undefined environment value : FLUENTD_HEALTHCHECK_ENDPOINT"}

until wget -q -O - http://${FLUENTD_HEALTHCHECK_ENDPOINT} >/dev/null 2>&1
do
  sleep 1s
done

exec php-fpm
