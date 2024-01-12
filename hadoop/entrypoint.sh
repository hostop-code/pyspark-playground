#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "namenode" ]; then
  hdfs namenode -format

  # Start the master node processes
  hdfs --daemon start namenode

  # If using YARN 
  # yarn --daemon start resourcemanager

  # Create required directories
  while ! hdfs dfs -mkdir -p /spark-logs; do
    echo "Failed creating /spark-logs hdfs dir"
  done
  echo "Created /spark-logs hdfs dir"
  hdfs dfs -mkdir -p /sample_data/
  echo "Created /sample_data/ hdfs dir"

  # Copy the data to the data HDFS directory
  hdfs dfs -copyFromLocal /opt/spark/data/* /sample_data
  hdfs dfs -ls /sample_data

  # For HIVE
  hdfs dfs -mkdir -p /warehouse/tablespace/managed/hive
  hdfs dfs -chmod -R 775 /warehouse
  # hdfs dfs -chown -R hive:hadoop /hive
  echo "Created /warehouse/tablespace/managed/hive hdfs dir"

  # start-master.sh -p 7077
fi

if [ "$WORKLOAD" == "secondarynamenode" ]; then
  echo "sleep 60 minute"
  sleep 60
  # hdfs namenode -format
  hdfs --daemon start secondarynamenode
fi

if [ "$WORKLOAD" == "datanode" ]; then
  hdfs namenode -format
  # start the worker node processes
  hdfs --daemon start datanode
fi

if [ "$WORKLOAD" == "yarn-resource-manager" ]; then
  
fi

if [ "$WORKLOAD" == "hive-metastore" ]; then
  # Connect Hive schema (PostgreSQL)
  ${HIVE_HOME}/bin/schematool -initSchema -dbType postgres 
  
  echo "Start Hive Metastore service"
  ${HIVE_HOME}/bin/hive --service metastore &
  echo "Success running metastore on port 9083"
fi

if [ "$WORKLOAD" == "trino" ]; then
  echo "Setup Trino Master"
  cp config-master.properties.template config.properties
fi

if [ "$WORKLOAD" == "worker" ]; then
  hdfs namenode -format
  # Start the worker node processes
  hdfs --daemon start datanode
  # yarn --daemon start nodemanager

  start-worker.sh spark://master:7077

  cp config-worker.properties.template config.properties
fi

if [ "$WORKLOAD" == "history" ]; then
  while ! hdfs dfs -test -d /spark-logs; do
    echo "spark-logs doesn't exist yet... retrying"
    sleep 1
  done
  echo "Exit loop"

  # Start the Spark history server
  start-history-server.sh
fi

if [ "$WORKLOAD" == "jupyter" ]; then
  echo "Setup Jupyter Lab"
  jupyter-lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='2wsx1qaz' --NotebookApp.password='2wsx1qaz' --notebook-dir=/opt/jupyter
fi

if [ "$WORKLOAD" == "zeppelin" ]; then
  echo "Starting Zeppelin Service"
  # zeppelin-daemon.sh start
  # hdfs namenode -format
fi

tail -f /dev/null
