#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "spark-master" ]; then
    # Start Spark master
    start-master.sh -p 7077 --webui-port 8080

    # Wait for a moment to ensure the Spark master has started
    echo "Waiting for Spark master to start..."
    sleep 30
    echo "Checking if Spark master is running on port 7077..."

    # Check if the Spark master service is active using netstat
    if netstat -tuln | grep ":7077" > /dev/null; then
        echo "Spark master is active on port 7077."
    else
        echo "Spark master is not active on port 7077."
    fi

    if netstat -tuln | grep ":8080" > /dev/null; then
        echo "Web UI is active on port 8080."
    else
        echo "Web UI is not active on port 8080."
    fi

elif [ "$WORKLOAD" == "spark-worker" ]; then

    echo "Waiting for 'spark-master' to be ready before connecting."

    check_spark_master_connection() {
        nc -zv spark-master 7077
    }

    # Loop to check the connection until it becomes active
    max_attempts=10

    for attempt in $(seq $max_attempts); do
        if check_spark_master_connection; then
            echo "Connection to 'spark-master' on port 7077 is active."
            break
        else
            echo "Attempt $attempt: Connection to 'spark-master' on port 7077 is not active. Retrying..."
            sleep 10  # Wait for 10 seconds before the next attempt
        fi
    done

    # Check if the connection is still not active after the maximum attempts
    if ! check_spark_master_connection; then
        echo "Maximum attempts reached. Exiting..."
        exit 1
    fi

    # Start spark-worker service
    echo "Start 'spark-worker' service"
    start-worker.sh spark://spark-master:7077
    # Sleep for 30 seconds
    sleep 30

    # Check if the spark-worker service is active using netstat
    # if netstat -tuln | grep ":4040" > /dev/null; then
    #     echo "spark-worker service is active on port 10000."
    # else
    #     echo "spark-worker service is not active on port 10000."
    # fi

elif [ "$WORKLOAD" == "spark-history-server" ]; then

    echo "Waiting for 'spark-master' to be ready before connecting."

    check_spark_master_connection() {
        nc -zv spark-master 7077
    }

    # Loop to check the connection until it becomes active
    max_attempts=10

    for attempt in $(seq $max_attempts); do
        if check_spark_master_connection; then
            echo "Connection to 'spark-master' on port 7077 is active."
            break
        else
            echo "Attempt $attempt: Connection to 'spark-master' on port 7077 is not active. Retrying..."
            sleep 10  # Wait for 10 seconds before the next attempt
        fi
    done

    # Check if the connection is still not active after the maximum attempts
    if ! check_spark_master_connection; then
        echo "Maximum attempts reached. Exiting..."
        exit 1
    fi

    # tidak bisa check folder, karena tidak ada hadoop di spark ini
    # while ! hdfs dfs -test -d /spark-logs;
    # do
    #     echo "spark-logs doesn't exist yet... retrying"
    #     sleep 1;
    # done
    # echo "Exit loop"

    # start the spark history server
    start-history-server.sh
    
    # Sleep for 30 seconds
    sleep 30

    Check if the Spark History Server service is active using netstat
    if netstat -tuln | grep ":18080" > /dev/null; then
        echo "Spark History Server service is active on port 18080."
    else
        echo "Spark History Server service is not active on port 18080."
    fi
    
else
    echo "Unknown workload: $WORKLOAD"
    exit 1
fi

tail -f /dev/null
