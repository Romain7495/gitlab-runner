FROM ubuntu:22.04

LABEL MAINTAINER=contact@romainlabat.fr

ARG K8S_VERSION
ARG HELM_VERSION
ARG YQ_VERSION
ARG HELM_URL="https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"
ARG K8S_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl"

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list  && \
    apt update && apt install -y gpg \
                        ca-certificates \
                        curl \
                        openssh \
                        jq \
                        openssl \
                        bash \
                        git \
                        perl \
                        gettext \
                        tar \
                        yq \
                        vault \
                        libcap \
                        kubectl \
                        helm \
                        gzip && \
    wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/salesforce/helm-starter.git && \
    helm plugin install https://github.com/databus23/helm-diff --version 3.1.2

CMD ["helm"]
