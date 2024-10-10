#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    CONTAINER_NAME="containerlab"

    if docker ps --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
        echo "Container '${CONTAINER_NAME}' is already running."
    else
        if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
            echo "Starting existing container '${CONTAINER_NAME}'..."
            docker start "${CONTAINER_NAME}"
        else
            echo "Running new container '${CONTAINER_NAME}'..."
            docker run -d \
                -p 2323:22 \
                --name "${CONTAINER_NAME}" \
                -v ~/Documents/:/home/clab-user/data \
                --privileged \
                basilelt/containerlab:latest
        fi
    fi

    echo "Waiting for SSH service to start..."
    sleep 5

    echo "Connecting to the container via SSH..."
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -X -p 2323 clab-user@localhost
fi