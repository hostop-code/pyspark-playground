FROM kevinity310/hadoop-base:3.2.4

LABEL maintainer="kevin-bda"

ARG HIVE_VERSION=3.1.3

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

ENV HIVE_HOME=/opt/hive
RUN mkdir -p $HIVE_HOME 

RUN curl -L https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz -o apache-hive-3.1.3-bin.tar.gz \
 && tar xvzf apache-hive-${HIVE_VERSION}-bin.tar.gz --directory ${HIVE_HOME} --strip-components 1 \
 && rm -rf apache-hive-${HIVE_VERSION}-bin.tar.gz

COPY conf/hive-site.xml $HIVE_HOME/conf/
COPY conf/hive-env.sh $HIVE_HOME/conf/
COPY conf/hive-config.sh $HIVE_HOME/bin/

# Config In HIVE
# Set environment variables in hive-config.sh
RUN echo 'export HADOOP_HOME=$HADOOP_HOME' >> "${HIVE_HOME}/bin/hive-config.sh" \
    && echo 'export HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE:-1024}' >> "${HIVE_HOME}/bin/hive-config.sh"

RUN mv $HIVE_HOME/lib/guava-19.0.jar $HIVE_HOME/lib/guava-19.0.jar.bak
RUN cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

ENV PATH="$HIVE_HOME/bin:${PATH}"

# Copy entrypoint script for HIVE
COPY entrypoint.sh entrypoint.sh

RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

EXPOSE 9083
EXPOSE 10000
EXPOSE 10002 

# CMD ["./entrypoint.sh"]

# docker build -t kevinity310/hive-metastore:3.1.3 .
# docker run --rm -it kevinity310/hive-metastore:3.1.3 /bin/bash