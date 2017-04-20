FROM frol/docker-alpine-oraclejdk8:01

COPY entrypoint.sh entrypoint.sh
RUN chmod a+x entrypoint.sh

COPY spring5-web.jar service.jar

ENTRYPOINT ["sh", "./entrypoint.sh"]
