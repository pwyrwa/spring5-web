#!/usr/bin/env bash

if [ "$1" == "--maven-build" ]; then
    mvn clean package -DskipTests=true
elif [ "$1" == "--cmd-build" ]; then
    docker build target/dockerBuildDir  -t piowyrwa/spring5-web:manual
elif [ "$1" == "--tag-latest" ]; then
    docker tag piowyrwa/spring5-web:0.0.20 piowyrwa/spring5-web:latest
elif [ "$1" == "--maven-push" ]; then
    mvn clean install -DskipTests=true
elif [ "$1" == "--cmd-push" ]; then
    docker push piowyrwa/spring5-web:manual
elif [ "$1" == "--run-http" ]; then
    docker run -p 2020:8080 -d --name upstream-ws piowyrwa/spring5-web:manual
elif [ "$1" == "--check-http" ]; then
    curl -v localhost:2020/healthcheck && echo && echo
elif [ "$1" == "--link-https" ]; then
    docker run -d -p 443:443 \
        -v ~/dev/ws/docker-nginx-reverse-proxy-ssl/logs:/var/log \
        -e NGINX_THREAD_POOL_SIZE="32" \
        -e NGINX_REQUEST_QUEUE_SIZE="1000" \
        -e UPSTREAM_PORT="8080" \
        --link upstream-ws:upstream \
        pio/nginx-ssl-proxy:latest
elif [ "$1" == "--check-https" ]; then
    curl -v -k https://localhost/healthcheck && echo && echo
elif [ "$1" == "--kill-all" ]; then
    docker kill $(docker ps -a -q)
elif [ "$1" == "--remove-all" ]; then
    docker rm $(docker ps -a -q)
elif [ "$1" == "--purge" ]; then
    # Attempt to remove running containers that are using the images we're trying to purge first.
    (docker rm -vf $(docker ps -a | grep "$2/\|/$2 \| $2 \|:$2\|$2-\|$2:\|$2_" | awk '{print $1}') 2>/dev/null || echo "No containers using the \"$2\" image, continuing purge.") &&\
    # Remove all images matching arg given after "--purge"
    docker rmi $(docker images | grep "$2/\|/$2 \| $2 \|$2 \|$2-\|$2_" | awk '{print $3}') 2>/dev/null || echo "No images matching \"$2\" to purge."
elif [ "$1" == "--mongo" ]; then
    docker run -d -p 3000:3000 mongoclient/mongoclient
else
       echo "U need to tell me what to do:"
       echo "   --maven-build, --cmd-build, --tag-latest, --maven-push"
       echo "   --maven-push, --cmd-push, --run-http, --check-http"
       echo "   --link-https, --check-https, --kill-all, --remove-all, --purge <name>, --mongo"
fi