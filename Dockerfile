FROM alpine

LABEL MAINTAINER=contact@romainlabat.fr

ARG K8S_VERSION
ARG HELM_VERSION
ARG YQ_VERSION
ARG HELM_URL="https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"
ARG YQ_URL="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64"
ARG K8S_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl"

RUN apk add --no-cache \
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
                        docker \
                        gzip && \
    curl ${YQ_URL} -o /usr/bin/yq && \
    curl ${K8S_URL} -o /usr/local/bin/kubectl && \
    curl ${HELM_URL} | bash && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/bin/yq && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/salesforce/helm-starter.git && \
    helm plugin install https://github.com/databus23/helm-diff --version 3.1.2

CMD ["helm"]
