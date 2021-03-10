本地部署 mock-server
-------------------------------------

* 可用的在线mock
[beeceptor](https://beeceptor.com/)
[swaggerhub](https://app.swaggerhub.com/apis/jamesdbloom/mock-server-openapi/5.11.x)
[stoplight](https://stoplight.io/welcome/)

* stoplight account

  + name: thomas.bian 
  + passwd: apulis@2025
* beeceptor
  + 2779026762@qq.com
  + apulis@2025
  + baseurl: https://apulis.free.beeceptor.com

1. 创建环境目录

```bash
mkdir -p /opt/mockserver
mkdir -p /opt/mockserver/config
docker pull mockserver/mockserver
docker-compose up -d
```

2. 本地docker-compose

```yaml
version: "2.4"
services:
  mockServer:
    image: mockserver/mockserver:latest
    ports:
      - 1080:1080
    environment:
      MOCKSERVER_PROPERTY_FILE: /opt/config/mockserver.properties
      MOCKSERVER_INITIALIZATION_JSON_PATH: /opt/config/initializerJson.json
    volumes:
      - type: bind
        source: .
        target: /config
```


3. 配置

```conf mockserver.properties
###############################
# MockServer & Proxy Settings #
###############################

# Socket & Port Settings

# socket timeout in milliseconds (default 120000)
mockserver.maxSocketTimeout=120000

# Certificate Generation

# dynamically generated CA key pair (if they don't already exist in specified directory)
mockserver.dynamicallyCreateCertificateAuthorityCertificate=true
# save dynamically generated CA key pair in working directory
mockserver.directoryToSaveDynamicSSLCertificate=.
# certificate domain name (default "localhost")
mockserver.sslCertificateDomainName=localhost
# comma separated list of ip addresses for Subject Alternative Name domain names (default empty list)
mockserver.sslSubjectAlternativeNameDomains=www.example.com,www.another.com
# comma separated list of ip addresses for Subject Alternative Name ips (default empty list)
mockserver.sslSubjectAlternativeNameIps=127.0.0.1

# CORS

# enable CORS for MockServer REST API
mockserver.enableCORSForAPI=true
# enable CORS for all responses
mockserver.enableCORSForAllResponses=true
```

4. 接口配置 

```json initializerJson.json
[
  {
    "httpRequest": {
      "path": "/firstExampleExpectation"
    },
    "httpResponse": {
      "body": "some response"
    }
  },
  {
    "httpRequest": {
      "path": "/secondExampleExpectation"
    },
    "httpResponse": {
      "body": "some response"
    }
  }
]
```

**参考**

1. [mock-server-docker_container](https://www.mock-server.com/mock_server/running_mock_server.html#docker_container)