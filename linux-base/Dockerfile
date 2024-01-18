# Use the official Ubuntu image as the base image
FROM ubuntu:22.04

LABEL maintainer="kevin"

# Disable interactive installation
ARG DEBIAN_FRONTEND=noninteractive

ARG HADOOP_VERSION=3.2.4


# Common requeriments for development
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      software-properties-common \
      sudo \
      vim \
      unzip \
      rsync \
      build-essential \
      dos2unix \
      nano \
      python3 \
      python3-pip \
      openssh-client \
      openssh-server \
  && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install tools required by the OS
RUN echo "For Networking"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      iputils-ping \
      wget \
      lsof \
      net-tools \
      nmap \
      netcat \
  && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Make python3 can run python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Print a message during the build process
RUN echo "INSTALLING Java v1.8, maven, wget, net_tools" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      maven \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# Generate SSH keys and configure
RUN mkdir -p ~/.ssh && \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

COPY ssh_config ~/.ssh/config

EXPOSE 22

# docker build -t kevinity310/ubuntu22.04:v1 .
# docker run --rm -it kevinity310/ubuntu22.04:v1 /bin/bash
# docker push kevinity310/ubuntu22.04:v1 
