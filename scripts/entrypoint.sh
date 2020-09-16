#!/bin/bash

### sabnzbdplus config
mkdir -p /config/sabnzbdplus \
    && cp -n /temp/sabnzbdplus.ini /config/sabnzbdplus/

### Infinite loop to stop docker from stopping ###
while true
do
    echo 'It is running'
    sleep 3600s
done
