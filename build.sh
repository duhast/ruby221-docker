#!/bin/bash

CONTAINER_NAME="ruby-2.2.1"

CONTAINER_REG_PREFIX="duhast/"
DATE_TAG=$(date +%Y%m%d)

CONTAINER_TAGS=(
  "${CONTAINER_REG_PREFIX}$CONTAINER_NAME:$DATE_TAG"
  "${CONTAINER_REG_PREFIX}$CONTAINER_NAME:latest"
)

docker build . \
  -t "${CONTAINER_TAGS[0]}" -t "${CONTAINER_TAGS[1]}" \
  --label "build-date=$DATE_TAG"

for container in "${CONTAINER_TAGS[@]}"; do docker push "$container"; done