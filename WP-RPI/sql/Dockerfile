FROM armhf/alpine:3.4
MAINTAINER Scott Mebberson <scott@scottmebberson.com>

# Install nginx
RUN  apk add --update mariadb &&  apk add --update bash &&\
    rm -rf /var/cache/apk/*

CMD ["mysqld_safe"]
# Expose the ports for nginx
EXPOSE 3306
