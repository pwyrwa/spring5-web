# spring5-web
Spring 5 web



## Build
* Build parent docker if needed [parent-docker](parent-docker/README.md) from parent-docker repo
* mvn package will build docker image
 
 
## Release

 * Add and activate profile with credentials to docker.io
 
 ```xml
 
     <profile>
       <id>personal-repository</id>
       <properties>
         <docker-io-username>USER-NAME</docker-io-username>
         <docker-io-password>PASSWORD</docker-io-password>
       </properties>
     </profile>
  ```
  ```xml        
     <activeProfiles>
        <activeProfile>personal-repository</activeProfile>
     </activeProfiles>
 ```

 * Run release script to update version and push docker
```bash
    ./releaase.sh
```
 
## Run

```bash
    docker run -it -p 8080:8080 piowyrwa/spring5-web:0.0.1-SNAPSHOT 
```
 
## Health check
 * http://host:port/pio-web/status
 * local: http://localhost:8080/pio-web/status 

