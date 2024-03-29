FROM alpine:edge
LABEL MAINTAINER=contact@romainlabat.fr

ARG DOCKER_ENABLED=false

RUN if [[ "$DOCKER_ENABLED" == "true" ]] ; then apk add --no-cache docker ; fi
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
                        npm \
                        yq \
                        libcap \
                        glab \
                        flarectl \
                        figlet \
                        helm@testing \
                        kubectl@testing \
                        vault  \
                        glab \
                        gzip && \
    setcap cap_ipc_lock= /usr/sbin/vault && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/salesforce/helm-starter.git && \
    npm install -g nx && npm install -g @datadog/datadog-ci
RUN git clone https://github.com/xero/figlet-fonts.git && mv figlet-fonts/*.flf /usr/share/figlet/fonts && rm -rf figlet-fonts

CMD ["helm"]