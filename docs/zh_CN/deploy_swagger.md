
* Running the image from DockerHub

There is a docker image published in DockerHub.To use this, run the following:

```bash
docker pull swaggerapi/swagger-editor
docker run -d -p 80:8080 swaggerapi/swagger-editor
```

This will run Swagger Editor (in detached mode) on port 80 on your machine, so you can open it by navigating to http://localhost in your browser.

You can provide your own json or yaml definition file on your host

`docker run -d -p 80:8080 -v $(pwd):/tmp -e SWAGGER_FILE=/tmp/swagger.json swaggerapi/swagger-editor`

You can provide a API document from your local machine — for example, if you have a file at ./bar/swagger.json:

`docker run -d -p 80:8080 -e URL=/foo/swagger.json -v /bar:/usr/share/nginx/html/foo swaggerapi/swagger-editor`

You can specify a different base url at which where to access the application - for example if you want to application to be available at http://localhost/swagger-editor/:

`docker run -d -p 80:8080 -e BASE_URL=/swagger-editor swaggerapi/swagger-editor`

* configuration

+ host: 192.168.1.204
+ conf: /opt/swagger
+ port: 8180
+ path: /swagger-editor
+ start_cmd: `docker run -d --restart unless-stopped -p 8180:8080 -e BASE_URL=/swagger-editor swaggerapi/swagger-editor`
---

* Refer:
1. [swagger_github](https://github.com/swagger-api/swagger-editor)