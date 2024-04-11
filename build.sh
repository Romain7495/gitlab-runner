#!/bin/bash

set -euo pipefail

export VERSION=${1:-latest}
export DOCKER_REPO=${2:-smoodci}/runner
# Build image

echo "Building image ${DOCKER_REPO}:${VERSION} without Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-slim \
             -t ${DOCKER_REPO}:latest-slim .
            
echo " Building image ${DOCKER_REPO}:${VERSION} with Docker"
echo
docker build -t ${DOCKER_REPO}:${VERSION} \
             -t ${DOCKER_REPO}:latest \
             --build-arg DOCKER_BASE_IMG_REPO=${DOCKER_REPO} \
             --build-arg DOCKER_BASE_IMG_TAG=${VERSION}-slim \
             -f Dockerfile.docker .

echo " Building image ${DOCKER_REPO}:${VERSION} with gcloud"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-gcloud-slim \
             -t ${DOCKER_REPO}:latest-gcloud-slim \
             --build-arg DOCKER_BASE_IMG_REPO=${DOCKER_REPO} \
             --build-arg DOCKER_BASE_IMG_TAG=${VERSION}-slim \
             -f Dockerfile.gcloud .

echo " Building image ${DOCKER_REPO}:${VERSION} with gcloud and gcloud"
echo
docker build -t ${DOCKER_REPO}:${VERSION}-gcloud \
             -t ${DOCKER_REPO}:latest-gcloud \
             --build-arg DOCKER_BASE_IMG_REPO=${DOCKER_REPO} \
             --build-arg DOCKER_BASE_IMG_TAG=${VERSION}-gcloud-slim \
             -f Dockerfile.gcloud.docker .

# Push image
docker push ${DOCKER_REPO}:${VERSION}-slim
docker push ${DOCKER_REPO}:latest-slim
docker push ${DOCKER_REPO}:${VERSION}
docker push ${DOCKER_REPO}:latest
docker push ${DOCKER_REPO}:${VERSION}-gcloud
docker push ${DOCKER_REPO}:latest-gcloud
docker push ${DOCKER_REPO}:${VERSION}-gcloud-slim
docker push ${DOCKER_REPO}:latest-gcloud-slim
