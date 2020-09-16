#!/bin/bash

### Set various variable values ###
echo ''
echo '[info] Setting variables'
source /set_variables.sh
echo '[info] All variables set'

### Fixing config files ###
echo ''
echo '[info] Fixing configs'
source /fix_config.sh
echo '[info] All configs fixed'

### Stubby DNS-over-TLS ###
echo ''
echo "[info] Run stubby in background on port $DNS_PORT"
stubby -g -C /config/stubby/stubby.yml
ipnaked=$(dig +short myip.opendns.com @208.67.222.222)
echo "[warn] Your ISP public IP is $ipnaked"

### nftables ###
echo ''
echo '[info] Set up nftables rules'
source /nftables.sh
echo '[info] All rules created'

### Quick block test ####
echo ''
ipttest=$(dig +short +time=5 +tries=1 myip.opendns.com @208.67.222.222)
echo "[info] Quick block test. Expected result is time out. Actual result is $ipttest"

### OpenVPN ###
echo ''
echo "[info] Setting up OpenVPN tunnel"
source /openvpn.sh
echo '[info] Done'

### Dante SOCKS proxy to VPN ###
echo ''
echo "[info] Run danted in background on port $DANTE_PORT"
danted -D -f /config/dante/danted.conf

### Tinyproxy HTTP proxy to VPN ###
echo ''
echo "[info] Run tinyproxy in background with no log on port $TINYPROXY_PORT"
tinyproxy -c /config/tinyproxy/tinyproxy.conf

### sabnzbdplus
echo '[info] Run sabnzbdplus in background'
sabnzbdplus --daemon --config-file /config/sabnzbdplus/sabnzbdplus.ini --pid /config/sabnzbdplus/

### Infinite loop to stop docker from stopping ###
while true
do
    echo 'It is running'
    sleep 3600s
done
