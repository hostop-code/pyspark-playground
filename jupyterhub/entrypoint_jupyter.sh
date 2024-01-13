#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "jupyterhub" ]; then

    # Check if the metastore service is active using netstat
    if netstat -tuln | grep ":9083" > /dev/null; then
        echo "Checking: Hive Metastore service is active on port 9083."
    else
        echo "Checking: Hive Metastore service is not active on port 9083."
    fi

else
    echo "Unknown workload: $WORKLOAD"
    exit 1
fi

tail -f /dev/null
