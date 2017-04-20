# spring5-web
Spring 5 web



## Build
* Build parent docker if needed [parent-docker](parent-docker/README.md) from parent-docker repo
* mvn package will build docker image
 
 
## Run

```bash
    docker run -it -p 8080:8080 pio/spring5-web:0.0.1-SNAPSHOT 
```
 
## Health check
http://host:port/pio-web/status
