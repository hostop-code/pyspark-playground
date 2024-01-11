# Use the official Python image as the base image
FROM ubuntu:22.04
LABEL maintainer="kevin"

# Disable interactive installation
ARG DEBIAN_FRONTEND=noninteractive

ARG HADOOP_VERSION=3.2.4

# Install tools required by the OS
RUN echo "Install tools package linunx for support development"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      software-properties-common \
      sudo \
      curl \
      iputils-ping \
      vim \
      unzip \
      rsync \
      build-essential \
      dos2unix \
      nano \
      python3 \
        python3-pip \
      wget \
    net-tools \
    openssh-client \
    && apt-get clean 

# Make python3 can run pyhton
RUN ln -s /usr/bin/python3 /usr/bin/python
    
# Print a message during the build process
RUN echo "INSTALING Java v1.8, maven, wget, net_tools"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      maven \
  && apt-get clean 
    # && rm -rf /var/lib/apt/lists/*

# Set environment variables JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# Generate SSH keys and configure
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

COPY ssh_config ~/.ssh/config

EXPOSE 22

# Set entry point
# ENTRYPOINT ["./entrypoint.sh"]
CMD ["./entrypoint.sh"]

# docker build -t kevinity310/ubuntu22.04 .

# docker compose -f docker-compose-ubuntu-standalone.yml build 
# docker run --rm -it Dockerfile-ubuntu-standalone /bin/bash

# service postgresql status