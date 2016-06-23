#!/bin/sh
set -eu

while true
do
  DATE=`date '+%d/%b/%Y:%H:%M:%S %z'`
  if test 0 -eq $(( RANDOM % 10 )) ; then
    echo "explicit error"
    #>&1
  else
    echo -e "172.17.0.1 - - [${DATE}] \"GET / HTTP/1.1\" 200 612 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36\" \"-\""
    #>&1
  fi
  #usleep 100000
  usleep 200000
done
