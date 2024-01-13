FROM kevinity310/ubuntu22.04:v1

ARG SPARK_VERSION=3.4.2

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

ENV SPARK_HOME=/opt/spark
RUN mkdir -p $SPARK_HOME
WORKDIR $SPARK_HOME
 
# Download and install Spark
RUN curl -L https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory ${SPARK_HOME} --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz

ENV PATH="$SPARK_HOME/sbin:/opt/spark/bin:${PATH}"

# Copy configuration files
COPY conf/spark-defaults.conf $SPARK_HOME/conf/
COPY conf/spark-env.sh $SPARK_HOME/conf/

# Make binaries and scripts executable, set PYTHONPATH
RUN chmod u+x $SPARK_HOME/sbin/* && \
    chmod u+x $SPARK_HOME/bin/* 

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

# Copy entrypoint script
COPY entrypoint-spark.sh entrypoint.sh

RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

EXPOSE 7077
EXPOSE 18080
EXPOSE 4040

# docker build -t kevinity310/spark-standalone:3.4.2 .
# docker run --rm -it kevinity310/spark-standalone:3.4.2 /bin/bash
# docker push kevinity310/ubuntu22.04:v1 

