#!/bin/sh
docker buildx build --platform linux/amd64,linux/arm64 -t n3rv4/php-apache:latest --push .
