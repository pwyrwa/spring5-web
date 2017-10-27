FROM lwieske/java-8:jdk-8u131

COPY entrypoint.sh entrypoint.sh
RUN chmod a+x entrypoint.sh

COPY spring5-web.jar service.jar

EXPOSE 8080

ENTRYPOINT ["sh", "./entrypoint.sh"]
