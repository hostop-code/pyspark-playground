# Use the official Python image as the base image
FROM kevinity310/ubuntu22.04:v1 

ARG HADOOP_VERSION=3.2.4

# Set environment variables JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# Setup the directories for Hadoop Installation
ENV HADOOP_HOME=/opt/hadoop
RUN mkdir -p $HADOOP_HOME
WORKDIR $HADOOP_HOME

# Download and install Hadoop
RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o hadoop-${HADOOP_VERSION}-bin.tar.gz \
 && tar xfz hadoop-${HADOOP_VERSION}-bin.tar.gz --directory ${HADOOP_HOME} --strip-components 1 \
 && rm -rf hadoop-${HADOOP_VERSION}-bin.tar.gz

ENV PATH="$HADOOP_HOME/bin:$HADOOP_HOME/sbin:${PATH}"
ENV HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"
ENV LD_LIBRARY_PATH="$HADOOP_HOME/lib/native:${LD_LIBRARY_PATH}"

# Set users for HDFS and Yarn
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

# Add JAVA_HOME to hadoop-env.sh
# RUN echo "export JAVA_HOME=${JAVA_HOME}" >> "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"

# Copy configuration files
ADD hdfs/*.xml $HADOOP_HOME/etc/hadoop/
ADD yarn/*.xml $HADOOP_HOME/etc/hadoop/

# Copy entrypoint script
COPY entrypoint.sh entrypoint.sh
RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh



# https://www.oreilly.com/library/view/big-data-analytics/9781788628846/5c5821cc-4a3d-498a-a3eb-23256cd79c8b.xhtml
EXPOSE 9087
EXPOSE 9000
EXPOSE 8030
EXPOSE 8031
EXPOSE 8032
EXPOSE 8033
EXPOSE 8088

# Set entry point
# ENTRYPOINT ["./entrypoint.sh"]
CMD ["./entrypoint.sh"]

# docker build -t kevinity310/hadoop-base:3.2.4 .
# docker push kevinity310/hadoop-base:3.2.4

# docker compose -f docker-compose-dev.yml build 
# docker run --rm -it kevinity310/hadoop-base:3.2.4 /bin/bash

# docker compose -f docker-compose-dev.yml build
