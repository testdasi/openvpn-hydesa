#!/bin/bash

update-locale LANG=$LANG
echo '[info] language fixed.'

sed -i "s|  - 0\.0\.0\.0\@53|  - 0\.0\.0\.0\@$DNS_PORT|g" '/etc/stubby/stubby.yml'
echo '[info] stubby fixed.'

sed -i "s|internal: eth0 port=1080|internal: eth0 port=$DANTE_PORT|g" '/etc/danted.conf'
echo '[info] danted fixed.'

sed -i "s|Port 8080|Port $TINYPROXY_PORT|g" '/etc/tinyproxy/tinyproxy.conf'
sed -i "s|upstream socks5 localhost:1080|upstream socks5 $ETH0_IP:$DANTE_PORT|g" '/etc/tinyproxy/tinyproxy.conf'
echo '[info] tinyproxy fixed.'

mkdir -p /config/sabnzbdplus \
    && cp -n /temp/sabnzbdplus.ini /config/sabnzbdplus/ \
    && mkdir -p /data/sabnzbdplus/watch \
    && mkdir -p /data/sabnzbdplus/incomplete \
    && mkdir -p /data/sabnzbdplus/complete \
    && mkdir -p /data/sabnzbdplus/script
echo '[info] sabnzbdplus fixed.'
