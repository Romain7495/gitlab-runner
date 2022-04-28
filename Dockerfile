FROM python:3-alpine

LABEL MAINTAINER=contact@romainlabat.fr

ARG K8S_VERSION
ARG HELM_VERSION
ARG GCLOUD_VERSION=310.0.0

ENV GCLOUD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz"
ENV CLOUD_SQL_PROXY="https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64"
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ADD https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.31.0/ytt-linux-amd64 /usr/local/bin/ytt

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl  \
 && apk add --update openssh  \
 && apk add --update docker  \
 && apk add --update py3-pip \
 && apk add --update jq  \
 && apk add --update npm  \
 && apk add --update openssl  \
 && apk add --update bash git perl \
 && apk add --update gettext tar gzip \
 && pip install j2cli \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
 && npm install --global @datadog/datadog-ci \
 && chmod +x /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/ytt \
 && rm /var/cache/apk/* \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 && helm plugin install https://github.com/salesforce/helm-starter.git \
 && helm plugin install https://github.com/databus23/helm-diff --version 3.1.2

# RUN \
#   curl https://sdk.cloud.google.com > install.sh && \
#   bash install.sh --disable-prompts

# SHELL ["/bin/bash", "-c"]

# RUN source /root/google-cloud-sdk/completion.bash.inc && \
#     source /root/google-cloud-sdk/path.bash.inc && \
#     echo "source /root/google-cloud-sdk/completion.bash.inc" >> ~/.bashrc && \
#     echo "source /root/google-cloud-sdk/path.bash.inc" >> ~/.bashrc

# ENV PATH="/root/google-cloud-sdk/bin:${PATH}"

CMD ["helm"]
