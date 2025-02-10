#!/bin/bash
set -e

echo "Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)

# Enable Docker BuildKit
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1

# Check if buildx exists, else create a new builder
if ! docker buildx ls | grep -q "multi-platform-builder"; then
    echo "Creating a new buildx builder for multi-platform support..."
    docker buildx create --name multi-platform-builder --use
fi

# Build multi-platform image
docker buildx build --platform linux/arm64 -t $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG --push .

# Scan image for vulnerabilities using Trivy
echo "Scanning Docker image for vulnerabilities..."
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --severity HIGH,CRITICAL $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

if [ $? -eq 1 ]; then
    echo "Image scanning failed due to HIGH or CRITICAL vulnerabilities."
    exit 1
fi

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
