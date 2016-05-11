#!/bin/bash
set -eu

function install_pcre() {
  if [ ! -e /usr/local/bin/pcretest ]; then
    pushd /usr/local/src
    curl --remote-name ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz
    tar -xzvf pcre-8.38.tar.gz
    pushd pcre-8.38
    ./configure
    make
    make install
    popd
    popd
  fi
}

function install_zlib() {
  if [ ! -e /usr/local/lib/libz.so ]; then
    pushd /usr/local/src
    curl --remote-name http://zlib.net/zlib-1.2.8.tar.gz
    tar -xzvf zlib-1.2.8.tar.gz
    pushd zlib-1.2.8
    ./configure
    make
    make install
    popd
    popd
  fi
}

function install_openssl() {
  if [ ! -d /usr/local/ssl ]; then
    pushd /usr/local/src
    curl --remote-name ftp://ftp.openssl.org/source/openssl-1.0.2h.tar.gz
    tar -xzvf openssl-1.0.2h.tar.gz
    pushd openssl-1.0.2h
    ./config -fPIC shared
    make
    make install
    popd
    popd
  fi
}


function install_apr() {
  if [ ! -e /usr/local/apr/bin/apr-1-config ]; then
    pushd /usr/local/src
    curl --remote-name http://ftp.jaist.ac.jp/pub/apache/apr/apr-1.5.2.tar.gz
    tar -xzvf apr-1.5.2.tar.gz
    pushd apr-1.5.2
    ./configure
    make
    make install
    popd
    popd
  fi
}

function install_apr_util() {
  install_apr

  if [ ! -e /usr/local/apr/bin/apu-1-config ]; then
    pushd /usr/local/src
    curl --remote-name http://ftp.jaist.ac.jp/pub/apache/apr/apr-util-1.5.4.tar.gz
    tar -xzvf apr-util-1.5.4.tar.gz
    pushd apr-util-1.5.4
    ./configure --with-apr=/usr/local/apr
    make
    make install
    popd
    popd
  fi
}

function install_libxml2() {
  if [ ! -L /usr/local/lib/libxml2.so ]; then
    pushd /usr/local/src
    curl --remote-name ftp://xmlsoft.org/libxml2/libxml2-2.9.3.tar.gz
    tar -xzvf libxml2-2.9.3.tar.gz
    pushd libxml2-2.9.3
    ./configure --without-python
    make
    make install
    popd
    popd
  fi
}

