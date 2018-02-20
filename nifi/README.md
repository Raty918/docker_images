# nifi

scalable nifi stack. You can scale zookeeper containers and nifi containers
Zookeeper minimum n° is 3.
consul template is used for zookeeper scaling and dynamic nifi reconfiguration

## REQUIREMENTS

recent versions docker & docker-compose

## Start the service

docker-compose -f docker-compose.test.yml up -d
docker-compose -f docker-compose.test.yml scale zookeeper=3

