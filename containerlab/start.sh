#!/bin/sh

# Start Docker daemon
echo "Starting Docker daemon..."
dockerd &

# Wait for Docker to be ready
echo "Waiting for Docker to be ready..."
until docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 1
done
echo "Docker is ready."

# Start SSHD
echo "Starting SSH daemon..."
/usr/sbin/sshd -D