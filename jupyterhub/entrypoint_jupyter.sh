#!/bin/bash

WORKLOAD=$1

echo "WORKLOAD: $WORKLOAD"

/etc/init.d/ssh start

if [ "$WORKLOAD" == "jupyterhub" ]; then

    # Check if the metastore service is active using netstat
    jupyterhub
    
    if netstat -tuln | grep ":8000" > /dev/null; then
        echo "Checking: JupyterHub service is active on port 8000."
    else
        echo "Checking: JupyterHub service is not active on port 8000."
    fi

else
    echo "Unknown workload: $WORKLOAD"
    exit 1
fi

tail -f /dev/null
