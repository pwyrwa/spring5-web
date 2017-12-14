#!/usr/bin/env bash

## Not working

if [ "$1" == "--start-web" ]; then
    docker run -itd --name upstream-ws piowyrwa/spring5-web:manual
elif [ "$1" == "--start-https" ]; then
    docker run -itd -p 443:443 \
        -v ~/dev/ws/docker-nginx-reverse-proxy-ssl/logs:/var/log \
        -e NGINX_THREAD_POOL_SIZE="32" \
        -e NGINX_REQUEST_QUEUE_SIZE="1000" \
        -e UPSTREAM_PORT="8080" \
        pio/nginx-ssl-proxy:latest
else
    echo "Tell me what to do"
fi