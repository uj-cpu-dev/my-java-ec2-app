#!/bin/bash
set -e

echo "Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)

# Enable Docker BuildKit
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1

# Detect architecture of the machine
ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    PLATFORM="linux/arm64"
elif [[ "$ARCH" == "x86_64" ]]; then
    PLATFORM="linux/amd64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Check if buildx exists, else create a new builder
if ! docker buildx ls | grep -q "multi-platform-builder"; then
    echo "Creating a new buildx builder for multi-platform support..."
    docker buildx create --name multi-platform-builder --use
fi

# Build multi-platform image
echo "Building multi-platform Docker image for amd64 and arm64..."
docker buildx build --platform linux/amd64,linux/arm64 -t $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG --push .

# Verify the multi-arch image
echo "Verifying built image manifest..."
docker manifest inspect $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG | jq '.manifests[].platform'

# Pull the correct architecture image
echo "Pulling Docker image for $PLATFORM..."
docker pull --platform $PLATFORM $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

# Get image size in MB
IMAGE_SIZE=$(docker image inspect $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG --format='{{.Size}}')
IMAGE_SIZE_MB=$((IMAGE_SIZE / 1024 / 1024))

echo "Docker image size: ${IMAGE_SIZE_MB}MB"

# Enforce max image size of 500MB
if [ "$IMAGE_SIZE_MB" -gt 500 ]; then
    echo "Error: Image size exceeds 500MB. Not pushing to ECR."
    exit 1
fi

echo "Pushing Docker image to ECR..."
docker push $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG
