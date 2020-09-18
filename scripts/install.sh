#!/bin/bash

# install deluge and deluge-web
apt-get -y update \
    && apt-get -y install deluged deluge-web screen

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

# fix static files for repo-specific stuff
sed -i "s|\/etc\/openvpn|\/config\/openvpn|g" '/static/scripts/openvpn.sh'
sed -i "s|\/etc\/openvpn|\/config\/openvpn|g" '/static/scripts/set_variables_ovpn_port_proto.sh'
sed -i "s|\/etc\/|\/config\/|g" '/static/scripts/fix_config_stubby.sh'
sed -i "s|\/etc\/|\/config\/|g" '/static/scripts/fix_config_dante.sh'
sed -i "s|\/etc\/|\/config\/|g" '/static/scripts/fix_config_tinyproxy.sh'
sed -i "s|\/etc\/|\/config\/|g" '/static/scripts/fix_config_sabnzbdplus.sh'
sed -i "s|\/etc\/|\/config\/|g" '/static/scripts/fix_config_deluge.sh'
sed -i "s|\/etc\/|\/config\/|g" '/static/scripts/fix_config_nzbhydra2.sh'

# chmod scripts
chmod +x /*.sh
