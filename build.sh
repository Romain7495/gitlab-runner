#!/bin/bash

set -euo pipefail

export VERSION=${1:-latest}
export DOCKER_REPO=${2:-smoodci}/runner
# Build image

echo "Building image ${DOCKER_REPO}:${VERSION} without Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-slim \
             -t ${DOCKER_REPO}:latest-slim \
            --build-arg DOCKER_ENABLED=false \
            --build-arg GCLOUD_ENABLED=false .
            
echo " Building image ${DOCKER_REPO}:${VERSION} with Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION} \
             -t ${DOCKER_REPO}:latest \
             --build-arg GCLOUD_ENABLED=false \
             --build-arg DOCKER_ENABLED=true .

echo " Building image ${DOCKER_REPO}:${VERSION} with gcloud"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-gcp-slim \
             -t ${DOCKER_REPO}:latest-gcp-slim \
            --build-arg DOCKER_ENABLED=false \
            --build-arg GCLOUD_ENABLED=true .

echo " Building image ${DOCKER_REPO}:${VERSION} with gcloud AND Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-gcp \
             -t ${DOCKER_REPO}:latest-gcp \
            --build-arg DOCKER_ENABLED=true \
            --build-arg GCLOUD_ENABLED=true .

# Push image
docker push ${DOCKER_REPO}:${VERSION}
docker push ${DOCKER_REPO}:${VERSION}-slim
docker push ${DOCKER_REPO}:latest
docker push ${DOCKER_REPO}:latest-slim
docker push ${DOCKER_REPO}:${VERSION}-gcp
docker push ${DOCKER_REPO}:latest-gcp
docker push ${DOCKER_REPO}:${VERSION}-gcp-slim
docker push ${DOCKER_REPO}:latest-gcp-slim
