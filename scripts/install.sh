#!/bin/bash

# install deluge and deluge-web
apt-get -y update \
    && apt-get -y install deluged deluge-web

# clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

# install static files
mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/testdasi/static/archive/master.zip" -o /temp/static.zip \
    && unzip /temp/static.zip \
    && rm -f /temp/static.zip \
    && mv /temp/static-master /static

# overwrite static with repo-specific stuff
cp -f /temp/* /static/config/ \
    && rm -rf /temp

# chmod scripts
chmod +x /*.sh
