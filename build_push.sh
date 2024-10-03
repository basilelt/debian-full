#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "Current directory (full path): $current_dir"
    cd "$current_dir"

    export DOCKER_BUILDKIT=1

    # Create a new builder instance if it doesn't exist
    if ! docker buildx inspect mybuilder > /dev/null 2>&1; then
        docker buildx create --name mybuilder --use
    fi

    # Build and push the image for arm64 and amd64
    docker buildx build --platform linux/arm64,linux/amd64 \
        -t basilelt/debian-full:latest \
        --push \
        .

    echo "Build and push completed successfully!"
fi