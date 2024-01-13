FROM kevinity310/hadoop-base:3.2.4 as spark_base

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
COPY spark/conf/spark-defaults.conf $SPARK_HOME/conf/
COPY spark/conf/spark-env.sh $SPARK_HOME/conf/

# Make binaries and scripts executable, set PYTHONPATH
RUN chmod u+x $SPARK_HOME/sbin/* && \
    chmod u+x $SPARK_HOME/bin/* 

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

FROM spark_base as jupyterhub_base

# Intalling Jupyterhub base doc : https://jupyterhub.readthedocs.io/en/stable/tutorial/quickstart.html

RUN echo "Install tools package linunx for support development"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      npm \
      nodejs \
    && apt-get clean 

ENV JUPYTER_HOME=/opt/jupyter 
RUN mkdir -p $JUPYTER_HOME
WORKDIR $JUPYTER_HOME

# Make python3 can run pyhton
# RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip install jupyterhub
RUN npm install -g configurable-http-proxy
RUN python3 -m pip install jupyterlab notebook

ADD jupyterhub_config.py $JUPYTER_HOME/jupyterhub_config.py

# Tambahkan pengguna baru
RUN useradd -m -s /bin/bash jupyter

# Ganti kata sandi pengguna jupyter
RUN echo "jupyter:jupyter" | chpasswd
# Tambahkan pengguna ke grup sudo

RUN usermod -aG sudo jupyter

USER jupyter

# docker build -t kevinity310/jupyterhub:latest .
# docker run --rm -it -p 8999:8000 kevinity310/jupyterhub:latest /bin/bash