#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# You can use any Debian/Ubuntu based image as a base
FROM debian:9

# Copy settings file so Docker extension is installed inside the container
COPY settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git, process tools installed
RUN apt-get -y install git procps

# Install Docker CE CLI
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
    && echo "deb https://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl

# Install Helm
RUN curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash -

# Install Skaffold
RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 \
    && chmod +x skaffold \
    && mv skaffold /usr/local/bin

# Copy localhost's ~/.kube/config file into the container and swap out localhost
# for host.docker.internal whenever a new shell starts to keep them in sync.
RUN echo '\n\
mkdir -p $HOME/.kube\n\
cp -r $HOME/.kube-localhost/* $HOME/.kube\n\
sed -i -e "s/localhost/host.docker.internal/g" $HOME/.kube/config' \
>> $HOME/.bashrc

# Copy localhost's minikube certificate file into the container and swap out localhost
RUN echo '\n\
mkdir -p $HOME/.minikube\n\
if [[ -f "$HOME/.minikube-localhost/ca.crt" ]]; then\n\
    cp -r $HOME/.minikube-localhost/ca.crt $HOME/.minikube\n\
    sed -i -r "s|(\s*certificate-authority:\s).*|\\1$HOME\/.minikube\/ca.crt|g" $HOME/.kube/config\n\
fi\n\
if [[ -f "$HOME/.minikube-localhost/client.crt" ]]; then\n\
    cp -r $HOME/.minikube-localhost/client.crt $HOME/.minikube\n\
    sed -i -r "s|(\s*client-certificate:\s).*|\\1$HOME\/.minikube\/client.crt|g" $HOME/.kube/config\n\
fi\n\
if [[ -f "$HOME/.minikube-localhost/client.key" ]]; then\n\
    cp -r $HOME/.minikube-localhost/client.key $HOME/.minikube\n\
    sed -i -r "s|(\s*client-key:\s).*|\\1$HOME\/.minikube\/client.key|g" $HOME/.kube/config\n\
fi' \
>> $HOME/.bashrc

# Install Elixir
ENV LANG=C.UTF-8
RUN curl -Lo erlang.deb https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang.deb \
    && rm erlang.deb \
    && apt-get update \
    && apt-get install -y esl-erlang elixir make gcc
RUN mix do local.hex --force, local.rebar --force

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog
