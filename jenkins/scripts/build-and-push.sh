#!/bin/bash
set -e

# Get the system architecture (e.g., amd64, arm64)
ARCHITECTURE=$(uname -m)

# Set platform based on the architecture
if [[ "$ARCHITECTURE" == "x86_64" ]]; then
    PLATFORM="linux/amd64"
elif [[ "$ARCHITECTURE" == "aarch64" ]]; then
    PLATFORM="linux/arm64"
else
    echo "Unsupported architecture: $ARCHITECTURE"
    exit 1
fi

echo "Building Docker image for platform $PLATFORM..."
IMAGE_TAG=$(cat image-tag.txt)

# Build Docker image for the selected platform
docker build --platform $PLATFORM -t $REPO_NAME:$IMAGE_TAG .

# Tag the image for pushing to ECR
docker tag $REPO_NAME:$IMAGE_TAG $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

echo "Pushing Docker image to ECR..."
docker push $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG
