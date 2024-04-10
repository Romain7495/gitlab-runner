# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set maintainer label
LABEL MAINTAINER=contact@romainlabat.fr

# Set Docker and GCloud arguments
ARG DOCKER_ENABLED=false
ARG GCLOUD_ENABLED=false

# Set PATH environment variable
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Install necessary packages and tools
RUN export DEBIAN_FRONTEND=noninteractive && \
    ln -fs /usr/share/zoneinfo/Europe/Zurich /etc/localtime && \
    apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl jq openssl bash git perl gettext tar libpcap-dev figlet tzdata dos2unix wget gzip apt-utils software-properties-common gcc make && \
    # Install Docker if DOCKER_ENABLED is true
    if [[ "$DOCKER_ENABLED" == "true" ]] ; then \
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
        chmod a+r /etc/apt/keyrings/docker.asc && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
        apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin ; \
    fi && \
    # Install GCloud SDK if GCLOUD_ENABLED is true
    if [[ "$GCLOUD_ENABLED" == "true" ]] ; then curl -sSL https://sdk.cloud.google.com | bash ; fi && \
    # Install Helm
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && apt-get install -y helm && \
    # Install Helm plugins
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/salesforce/helm-starter.git && \
    # Install kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install -y kubectl && \
    # Install glab CLI
    curl -sSL "https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository" | bash && \
    apt-get install -y glab && \
    # Install Vault
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install vault -y && \
    setcap -r /usr/bin/vault && \
    # Install YQ
    add-apt-repository ppa:rmescandon/yq && apt-get update && apt-get install yq -y && \
    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    # Cleanup
    rm -rf /var/lib/apt/lists/* && \
    # Install datadog-ci and nx
    npm install -g nx @datadog/datadog-ci

# Clone figlet-fonts repository and move fonts to the appropriate directory
RUN git clone https://github.com/xero/figlet-fonts.git && mv figlet-fonts/*.flf /usr/share/figlet/ && rm -rf figlet-fonts

# Set the default command to helm
CMD ["helm"]