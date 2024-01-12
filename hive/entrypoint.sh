#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "hive-metastore" ]; then
    # Connect Hive schema (PostgreSQL)
  ${HIVE_HOME}/bin/schematool -initSchema -dbType postgres 
  
  echo "Start Hive Metastore service"
  ${HIVE_HOME}/bin/hive metastore & 
  echo "Success running metastore on port 9083"
fi

if [ "$WORKLOAD" == "hive-server2" ]; then
  echo "Sabar"
fi

tail -f /dev/null
