#!/bin/bash

set -euo pipefail

export VERSION=${1:-latest}
export DOCKER_REPO=${2:-smoodci}/runner
# Build image

echo "Building image ${DOCKER_REPO}:${VERSION} without Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-slim \
             -t ${DOCKER_REPO}:latest-slim \
            --build-arg DOCKER_ENABLED=false .
            
echo " Building image ${DOCKER_REPO}:${VERSION} with Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION} \
             -t ${DOCKER_REPO}:latest \
            --build-arg DOCKER_ENABLED=true .

docker tag ${DOCKER_REPO}:${VERSION} ${DOCKER_REPO}:latest

# Push image
docker push ${DOCKER_REPO}:${VERSION}
docker push ${DOCKER_REPO}:${VERSION}-slim
docker push ${DOCKER_REPO}:latest
docker push ${DOCKER_REPO}:latest-slim