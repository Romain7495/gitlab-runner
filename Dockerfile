# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set maintainer label
LABEL MAINTAINER=contact@romainlabat.fr

# Set Docker and GCloud arguments
ARG DOCKER_ENABLED=false
ARG GCLOUD_ENABLED=false
ARG DEBIAN_FRONTEND=noninteractive
# Set PATH environment variable
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Install necessary packages and tools
RUN ln -fs /usr/share/zoneinfo/Europe/Zurich /etc/localtime
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates unzip curl jq openssl bash git perl gettext tar libpcap-dev figlet tzdata dos2unix wget gzip apt-utils software-properties-common gcc make gnupg lsb-release && \
    rm -rf /var/lib/apt/lists/*
# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && apt-get install -y helm && rm -rf /var/lib/apt/lists/*
# Install Helm plugins
RUN helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/salesforce/helm-starter
# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install -y kubectl && rm -rf /var/lib/apt/lists/*
# Install glab CLI
RUN curl -sSL "https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository" | bash && \
    apt-get install -y glab && rm -rf /var/lib/apt/lists/*
# Install Vault
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install vault -y && \
    setcap -r /usr/bin/vault && rm -rf /var/lib/apt/lists/*
# Install YQ
RUN add-apt-repository ppa:rmescandon/yq && apt-get update && apt-get install yq -y && rm -rf /var/lib/apt/lists/*
# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
# Install Trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/trivy.list && \
    apt-get update && apt-get install trivy -y && rm -rf /var/lib/apt/lists/*

# Install datadog-ci and nx
RUN npm install -g nx @datadog/datadog-ci

# Clone figlet-fonts repository and move fonts to the appropriate directory
RUN git clone https://github.com/xero/figlet-fonts.git && mv figlet-fonts/*.flf /usr/share/figlet/ && rm -rf figlet-fonts

# Set the default command to helm
CMD ["helm"]