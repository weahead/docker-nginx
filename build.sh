#!/bin/bash

NGINX_VERSION=1.9.15

# Enable when Docker Hub supports build args.
# docker build --build-arg NGINX_VERSION=${NGINX_VERSION} -t weahead/nginx:${NGINX_VERSION} .
docker build -t weahead/nginx:${NGINX_VERSION} .
