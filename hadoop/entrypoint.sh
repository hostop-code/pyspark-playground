#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "namenode" ]; then
  hdfs namenode -format -nonInteractive

  # Start the master node processes
  hdfs --daemon start namenode

fi

if [ "$WORKLOAD" == "secondarynamenode" ]; then
  echo "sleep 60 minute"
  sleep 60
  hdfs --daemon start secondarynamenode
fi

if [ "$WORKLOAD" == "datanode" ]; then
  hdfs namenode -format -nonInteractive

  
  # start the worker node processes
  echo "Start Datanode"
  hdfs --daemon start datanode

  # Create required directories if not exist
  while ! hdfs dfs -test -d /spark-logs; do
    hdfs dfs -mkdir /spark-logs
    echo "Created /spark-logs hdfs dir"
  done

  while ! hdfs dfs -test -d /sample_data; do
    hdfs dfs -mkdir /sample_data
    echo "Created /sample_data/ hdfs dir"
  done

  # Check if /sample_data is empty before copying
  if [ "$(hdfs dfs -count /sample_data | awk '{print $2}')" -eq 0 ]; then
    # Copy the data to the data HDFS directory
    hdfs dfs -copyFromLocal /tmp/sample_data/* /sample_data
    echo "Copied data to /sample_data"
  else
    echo "/sample_data already contains data. Skipping copy."
  fi
  # hdfs dfs -ls /sample_data

  # For HIVE
  hdfs dfs -mkdir -p /warehouse/tablespace/managed/hive
  hdfs dfs -chmod -R 775 /warehouse
  # hdfs dfs -chown -R hive:hadoop /hive
  echo "Created /warehouse/tablespace/managed/hive hdfs dir"
fi

if [ "$WORKLOAD" == "yarn-resource-manager" ]; then

  # Activate yarn resourcemanager
  yarn --daemon start resourcemanager

fi

if [ "$WORKLOAD" == "yarn-node-manager" ]; then

  # Activate yarn node manager
  yarn --daemon start nodemanager

fi

if [ "$WORKLOAD" == "hive-metastore" ]; then
  # Connect Hive schema (PostgreSQL)
  ${HIVE_HOME}/bin/schematool -initSchema -dbType postgres 
  
  echo "Start Hive Metastore service"
  ${HIVE_HOME}/bin/hive --service metastore &
  echo "Success running metastore on port 9083"
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

tail -f /dev/null
