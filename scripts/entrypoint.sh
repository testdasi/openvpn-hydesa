#!/bin/bash

### sabnzbdplus config
echo '[info] Creating sabnzbdplus config if not exist'
mkdir -p /config/sabnzbdplus \
    && cp -n /temp/sabnzbdplus.ini /config/sabnzbdplus/

### Infinite loop to stop docker from stopping ###
while true
do
    echo 'It is running'
    sleep 3600s
done
