#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
    # Add any necessary cleanup actions here
}

function create_or_use_builder() {
    local builder_name="$1"
    local driver="$2"
    if docker buildx inspect "$builder_name" > /dev/null 2>&1; then
        echo "Using existing builder '$builder_name'"
        docker buildx use "$builder_name"
    else
        echo "Creating new builder '$builder_name'"
        docker buildx create --name "$builder_name" --driver "$driver" --use
    fi
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "Current directory (full path): $current_dir"
    cd "$current_dir"

    export DOCKER_BUILDKIT=1

    read -p "Do you want to build for cloud or local? (cloud/local): " BUILD_TYPE

    case "$BUILD_TYPE" in
        cloud)
            echo "Building for cloud..."
            create_or_use_builder "cloud-basilelt-cloud-builder" "cloud basilelt/cloud-builder"
            docker buildx build --platform linux/amd64,linux/arm64 \
                -t basilelt/containerlab:latest \
                --push \
                .
            ;;
        local)
            echo "Building for local (multi-platform)..."
            create_or_use_builder "local-builder" "docker-container"
            
            # Build multi-platform images
            docker buildx build --platform linux/amd64,linux/arm64 \
                -t basilelt/containerlab:latest \
                --push \
                .
            
            echo "Multi-platform build completed and pushed to registry."
            
            # Pull the image for the current architecture
            echo "Pulling image for current architecture..."
            docker pull basilelt/containerlab:latest
            
            # Verify the image is present
            if docker image inspect basilelt/containerlab:latest > /dev/null 2>&1; then
                echo "Image successfully pulled and available in local Docker daemon."
            else
                echo "Error: Image not found in local Docker daemon after pull."
                exit 1
            fi
            ;;
    esac

    echo "Build completed successfully!"
fi