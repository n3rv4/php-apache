#!/bin/sh
docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t n3rv4/php-apache:latest --push .
