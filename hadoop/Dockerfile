# Use the official Python image as the base image
FROM ubuntu:22.04 as linux-base

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
      wget \
    net-tools \
  && apt-get clean 
    # && rm -rf /var/lib/apt/lists/*

# Set environment variables JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

FROM linux-base as hadoop-base

# Setup the directories for Hadoop Installation
ENV HADOOP_HOME=/opt/hadoop
RUN mkdir -p $HADOOP_HOME
WORKDIR $HADOOP_HOME

# Download and install Hadoop
RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o hadoop-${HADOOP_VERSION}-bin.tar.gz \
 && tar xfz hadoop-${HADOOP_VERSION}-bin.tar.gz --directory ${HADOOP_HOME} --strip-components 1 \
 && rm -rf hadoop-${HADOOP_VERSION}-bin.tar.gz

# Install Python dependencies
COPY requirements/requirements.txt .
RUN pip3 install -r requirements.txt

ENV PATH="$HADOOP_HOME/bin:$HADOOP_HOME/sbin:${PATH}"
ENV HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"
ENV LD_LIBRARY_PATH="$HADOOP_HOME/lib/native:${LD_LIBRARY_PATH}"

# Set users for HDFS and Yarn
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

# Add JAVA_HOME to haddop-env.sh
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"

# Copy configuration files
COPY hadoop/*.xml $HADOOP_HOME/etc/hadoop/

# Generate SSH keys and configure
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

COPY ssh_config ~/.ssh/config

# Copy entrypoint script
COPY entrypoint-standalone.sh entrypoint.sh

RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

EXPOSE 22

# Set entry point
# ENTRYPOINT ["./entrypoint.sh"]
CMD ["./entrypoint.sh"]

# docker build -t kevinity310/trino-base:435 .

# docker compose -f docker-compose-ubuntu-standalone.yml build 
# docker run --rm -it Dockerfile-ubuntu-standalone /bin/bash

# service postgresql status