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
echo "[info] Run sabnzbdplus in background on HTTP port $SAB_PORT_A and HTTPS port $SAB_PORT_B"
sabnzbdplus --daemon --config-file /config/sabnzbdplus/sabnzbdplus.ini --pidfile /config/sabnzbdplus/sabnzbd.pid

### deluge-web
echo "[info] Run deluge-web in background on HTTP port $DELUGE_PORT"
#deluged --quiet --config=/config/deluge
deluge-web --fork --quiet --config=/config/deluge-web

### nzbhydra2
echo "[info] Run nzbhydra2 in background on port $HYDRA_PORT"
/app/nzbhydra2/nzbhydra2 --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid

### Infinite loop to stop docker from stopping ###
cd /
sleep 10s
while true
do
    echo ''
    iphiden=$(dig +short myip.opendns.com @208.67.222.222)
    echo "[info] Your VPN public IP is $iphiden"
    pidlist=$(pidof openvpn)
    echo "[info] OpenVPN PID: $pidlist"
    pidlist=$(pidof stubby)
    echo "[info] stubby PID: $pidlist"
    pidlist=$(pidof danted)
    echo "[info] danted PID: $pidlist"
    pidlist=$(pidof tinyproxy)
    echo "[info] tinyproxy PID: $pidlist"
    pidlist=$(cat /config/sabnzbdplus/sabnzbd.pid)
    echo "[info] sabnzbdplus PID: $pidlist"
    pidlist=$(cat /config/nzbhydra2/nzbhydra2.pid)
    echo "[info] nzbhydra2 PID: $pidlist"
    sleep 3600s
done
