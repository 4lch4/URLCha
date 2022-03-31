#!/bin/bash

docker run -d \
  -e API_PREFIX="/api/v1" \
  -e APP_NAME="Koa-API-Template" \
  -e APP_VERSION="0.0.1" \
  -e APP_PORT=8080 \
  -d -p 8080:8080 \
  --name koa-api-template 4lch4/koa-api-template:latest

docker logs koa-api-template --follow
