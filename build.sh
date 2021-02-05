#!/bin/bash

set -euo pipefail

export DOCKER_REPO=rlabat/helmytt
export K8S_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/kubernetes/kubernetes/releases/latest | cut -d '/' -f 8)
export HELM_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/helm/helm/releases/latest | cut -d '/' -f 8)

export RELEASE=${K8S_VERSION}-${HELM_VERSION}

# Build image
docker build -t ${DOCKER_REPO}:${RELEASE} \
    --build-arg K8S_VERSION=${K8S_VERSION} \
    --build-arg HELM_VERSION=${HELM_VERSION} .

docker tag ${DOCKER_REPO}:${RELEASE} ${DOCKER_REPO}:latest

# Push image
docker push ${DOCKER_REPO}:${RELEASE}
docker push ${DOCKER_REPO}:latest
