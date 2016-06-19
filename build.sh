#!/bin/sh

NGINX_VERSION=1.10.1

# Enable when Docker Hub supports build args.
# docker build --build-arg NGINX_VERSION=${NGINX_VERSION} -t weahead/nginx:${NGINX_VERSION} .
docker build -t weahead/nginx:${NGINX_VERSION} .
