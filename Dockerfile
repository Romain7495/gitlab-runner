FROM alpine:3.13

LABEL MAINTAINER=contact@romainlabat.fr

ARG K8S_VERSION
ARG HELM_VERSION
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ADD https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.31.0/ytt-linux-amd64 /usr/local/bin/ytt

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl  \
 && apk add --update openssh  \
 && apk add --update docker  \
 && apk add --update jq  \
 && apk add --update openssl  \
 && apk add --update bash git perl \
 && apk add --update gettext tar gzip \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
 && chmod +x /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/ytt \
 && apk del --purge deps \
 && rm /var/cache/apk/* \
 && helm plugin install https://github.com/databus23/helm-diff --version 3.1.2

CMD ["helm"]
