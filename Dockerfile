FROM alpine:edge
LABEL MAINTAINER=contact@romainlabat.fr
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache \
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
                        yq \
                        libcap \
                        helm@testing \
                        kubectl@testing \
                        vault  \
                        gzip && \
    setcap cap_ipc_lock= /usr/sbin/vault && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/salesforce/helm-starter.git 
CMD ["helm"]