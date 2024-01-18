#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

check_error() {
  if [ $? -ne 0 ]; then
    echo "Error occurred. Exiting..."
    exit 1
  fi
}

if [ "$WORKLOAD" == "namenode" ]; then
  hdfs namenode -format -nonInteractive

  # Start the master node processes
  hdfs --daemon start namenode
  check_error
fi

if [ "$WORKLOAD" == "secondarynamenode" ]; then
  echo "sleep 60 minutes"
  sleep 60
  hdfs --daemon start secondarynamenode
  check_error
fi

if [ "$WORKLOAD" == "datanode" ]; then
  hdfs datanode -format -nonInteractive
  # check_error

  # start the worker node processes
  echo "Start Datanode"
  hdfs --daemon start datanode
  # check_error

  # Create required directories if not exist
  while ! hdfs dfs -test -d /spark-logs; do
    hdfs dfs -mkdir /spark-logs
    echo "Created /spark-logs hdfs dir"
    # check_error
  done

  while ! hdfs dfs -test -d /sample_data; do
    hdfs dfs -mkdir /sample_data
    echo "Created /sample_data/ hdfs dir"
    # check_error
  done

  # Check if /sample_data is empty before copying
  if [ "$(hdfs dfs -count /sample_data | awk '{print $2}')" -eq 0 ]; then
    # Copy the data to the data HDFS directory
    hdfs dfs -copyFromLocal /tmp/sample_data/* /sample_data
    echo "Copied data to /sample_data"
    hdfs dfs -chmod -R a+r /sample_data
    # check_error
  else
    echo "/sample_data already contains data. Skipping copy."
  fi

  # Create required directories if not exist
  while ! hdfs dfs -test -d /spark-logs; do
    hdfs dfs -mkdir /spark-logs
    echo "Created /spark-logs hdfs dir"
    # check_error
  done

  # For HIVE
  while ! hdfs dfs -test -d /warehouse/tablespace/managed/hive; do
    hdfs dfs -mkdir -p /warehouse/tablespace/managed/hive
    hdfs dfs -chmod -R 775 /warehouse
    echo "Created /warehouse/tablespace/managed/hive hdfs dir"
  done
  # check_error
fi

if [ "$WORKLOAD" == "yarn-resource-manager" ]; then
  # Activate YARN ResourceManager
  yarn --daemon start resourcemanager
  if [ $? -eq 0 ]; then
    echo "YARN ResourceManager started successfully."
  else
    echo "Error starting YARN ResourceManager. Exiting..."
    exit 1
  fi
fi

if [ "$WORKLOAD" == "yarn-node-manager" ]; then
  # Activate YARN NodeManager
  yarn --daemon start nodemanager
  if [ $? -eq 0 ]; then
    echo "YARN NodeManager started successfully."
  else
    echo "Error starting YARN NodeManager. Exiting..."
    exit 1
  fi
fi
tail -f /dev/null
