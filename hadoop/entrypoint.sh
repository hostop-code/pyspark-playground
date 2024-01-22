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
  echo "Waiting for 'hdfs-namenode' to be ready before connecting."

  check_hdfs_namenode_connection() {
      nc -zv hdfs-namenode 9000
  }

  # Loop to check the connection until it becomes active
  max_attempts=10

  for attempt in $(seq $max_attempts); do
      if check_hdfs_namenode_connection; then
          echo "Connection to 'hdfs-namenode' on port 9000 is active."
          break
      else
          echo "Attempt $attempt: Connection to 'hdfs-namenode' on port 9000 is not active. Retrying..."
          sleep 10  # Wait for 10 seconds before the next attempt
      fi
  done

  # sleep 60
  hdfs --daemon start secondarynamenode
  
else
  echo "Unknown workload: $WORKLOAD"
fi

if [ "$WORKLOAD" == "datanode" ]; then
    echo "Waiting for 'hdfs-namenode' to be ready before connecting."

    check_hdfs_namenode_connection() {
        nc -zv hdfs-namenode 9000
    }

    # Loop to check the connection until it becomes active
    max_attempts=10

    for attempt in $(seq $max_attempts); do
        if check_hdfs_namenode_connection; then
            echo "Connection to 'hdfs-namenode' on port 9000 is active."
            break
        else
            echo "Attempt $attempt: Connection to 'hdfs-namenode' on port 9000 is not active. Retrying..."
            sleep 10  # Wait for 10 seconds before the next attempt
        fi
    done

    hdfs datanode -format -nonInteractive

    # Start the worker node processes
    echo "Starting Datanode"
    hdfs --daemon start datanode

    # Create required directories if not exist
    create_hdfs_directory() {
        local dir=$1
        while ! hdfs dfs -test -d "$dir"; do
            hdfs dfs -mkdir "$dir"
            echo "Created $dir hdfs dir"
            # check_error
        done
    }

    create_hdfs_directory "/spark-logs"
    create_hdfs_directory "/sample_data"

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

    create_hdfs_directory "/spark-logs"

    # For HIVE
    create_hdfs_directory "/warehouse/tablespace/managed/hive"
    hdfs dfs -chmod -R 775 /warehouse

    echo "Created /warehouse/tablespace/managed/hive hdfs dir"
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
