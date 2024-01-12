FROM kevinity310/hadoop-base:3.2.4

LABEL maintainer="kevin-bda"

ARG SPARK_VERSION=3.4.2

ENV SPARK_HOME=/opt/spark
RUN mkdir -p $SPARK_HOME
WORKDIR $SPARK_HOME
 
# Download and install Spark
RUN curl -L https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory ${SPARK_HOME} --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

ENV PATH="$ZEPPELIN_HOME/bin:$SPARK_HOME/sbin:/opt/spark/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin:${PATH}"

