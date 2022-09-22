#!/bin/bash

set -euo pipefail

export VERSION=${1:-latest}
export DOCKER_REPO=${2:-smoodci}/runner
# Build image
docker build -t ${DOCKER_REPO}:${VERSION} \
             -t ${DOCKER_REPO}:latest \
            --build-arg K8S_VERSION \
            --build-arg HELM_VERSION .

docker tag ${DOCKER_REPO}:${VERSION} ${DOCKER_REPO}:latest

# Push image
docker push ${DOCKER_REPO}:${VERSION}
docker push ${DOCKER_REPO}:latest