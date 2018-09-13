FROM jenkins/jnlp-slave:3.10-1

USER root

RUN apt-get update && apt-get install -y git curl wget nano sudo

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# Install docker
RUN curl -fsSL get.docker.com -o get-docker.sh && chmod +x get-docker.sh
RUN ./get-docker.sh
RUN usermod -aG docker jenkins

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.11.2
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

#Install JFrog CLI and Helm CLI
RUN curl -fL https://getcli.jfrog.io | sh && mv jfrog /usr/local/bin/jfrog && chmod 777 /usr/local/bin/jfrog
RUN curl -fL -O https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz && tar -xvf helm-v2.9.1-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && rm -f helm-v2.9.1-linux-amd64.tar.gz && chmod 777 /usr/local/bin/helm

ENTRYPOINT ["jenkins-slave"]