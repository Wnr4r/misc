#!/bin/bash

# Function to check HTTP status of an endpoint
check_endpoint() {
    response=$(timeout 60 curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
    
    if [ $? -eq 124 ]; then
        echo "Endpoint is not available within 1 minute"
        restart_container
    elif [ $response -eq 200 ]; then
        echo "Endpoint is available"
    else
        echo "Endpoint is not available"
        restart_container
    fi
}

# Function to restart a Docker container
restart_container() {
    sudo docker restart <container_id>
    echo "Container restarted"
}

# Check the endpoint status
check_endpoint
