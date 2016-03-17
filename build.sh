#!/bin/bash

NGINX_VERSION=1.9.11

docker build --build-arg NGINX_VERSION=${NGINX_VERSION} -t weahead/nginx:${NGINX_VERSION} .
