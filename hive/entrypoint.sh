#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "hive-metastore" ]; then
    # Connect Hive schema (PostgreSQL)
    ${HIVE_HOME}/bin/schematool -initSchema -dbType postgres

    echo "Start Hive Metastore service"
    ${HIVE_HOME}/bin/hive --service metastore & 
    # echo "Success running metastore on port 9083"

  # Wait for a moment to ensure the service has started
    echo "Wait for a moment to ensure the service 'hive metastore' has started..."
    sleep 120
    echo "Checking port service 'hive metastore' is run..."

    # Check if the metastore service is active using netstat
    if netstat -tuln | grep ":9083" > /dev/null; then
        echo "Checking: Hive Metastore service is active on port 9083."
    else
        echo "Checking: Hive Metastore service is not active on port 9083."
    fi

elif [ "$WORKLOAD" == "hive-server2" ]; then

    echo "Waiting for hive-metastore to be ready before connecting."

    sleep 60

    check_metastore_connection() {
        nc -zv hive-metastore 9083
    }

    # Loop to check the connection until it becomes active
    max_attempts=5

    for attempt in $(seq $max_attempts); do
        if check_metastore_connection; then
            echo "Connection to Hive Metastore on port 9083 is active."
            break
        else
            echo "Attempt $attempt: Connection to Hive Metastore on port 9083 is not active. Retrying..."
            sleep 10  # Wait for 10 seconds before the next attempt
        fi
    done

    # Check if the connection is still not active after the maximum attempts
    if ! check_metastore_connection; then
        echo "Maximum attempts reached. Exiting..."
        exit 1
    fi

    # Start HiveServer2 service
    echo "Start HiveServer2 service"
    ${HIVE_HOME}/bin/hive --service hiveserver2 --hiveconf hive.server2.thrift.port=10000 --hiveconf hive.root.logger=INFO,console &

    # Sleep for 30 seconds
    sleep 30

    # Check if the HiveServer2 service is active using netstat
    if netstat -tuln | grep ":10000" > /dev/null; then
        echo "HiveServer2 service is active on port 10000."
    else
        echo "HiveServer2 service is not active on port 10000."
    fi

else
    echo "Unknown workload: $WORKLOAD"
    exit 1
fi

tail -f /dev/null
