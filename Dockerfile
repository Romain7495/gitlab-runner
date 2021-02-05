FROM lwolf/helm-kubectl-docker

ADD https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.31.0/ytt-linux-amd64 /usr/local/bin/ytt

RUN chmod +x /usr/local/bin/ytt
