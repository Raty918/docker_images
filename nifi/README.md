# nifi

## description
scalable nifi stack. You can scale zookeeper containers and nifi containers
consul template is used for zookeeper scaling and dynamic nifi reconfiguration

## requirements
recent versions of docker & docker-compose

## Start the service
```docker-compose -f docker-compose.test.yml up -d```

## best practices
### have 3 zookeeper nodes, which allows one of them to fail
```docker-compose -f docker-compose.test.yml scale zookeeper=3```

### have 3 nifi nodes, which allows one of them to fail
```docker-compose -f docker-compose.test.yml scale nifi_node=3```

