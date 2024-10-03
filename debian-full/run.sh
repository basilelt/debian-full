#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    CONTAINER_NAME="debian-full"

    if docker ps --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
        echo "Container '${CONTAINER_NAME}' is already running."
    else
        if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
            echo "Starting existing container '${CONTAINER_NAME}'..."
            docker start "${CONTAINER_NAME}"
        else
            echo "Running new container '${CONTAINER_NAME}'..."
            docker run -d \
                -p 2222:22 \
                -p 4443:443 \
                -p 8080:80 \
                --name "${CONTAINER_NAME}" \
                -v ~/Documents/:/home/toto/data \
                basilelt/debian-full:latest
        fi
    fi

    echo "Waiting for SSH service to start..."
    sleep 5

    echo "Connecting to the container via SSH..."
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -X -p 2222 toto@localhost
fi
