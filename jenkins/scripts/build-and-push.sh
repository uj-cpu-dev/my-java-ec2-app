#!/bin/bash
set -e  # Exit on error

echo "🚀 Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)
ECR_IMAGE="$ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG"

# Enable Docker BuildKit
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1

# Detect machine architecture
ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    PLATFORM="linux/arm64"
elif [[ "$ARCH" == "x86_64" ]]; then
    PLATFORM="linux/amd64"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

echo "🛠 Detected architecture: $ARCH ($PLATFORM)"

# Check if buildx exists, else create a new builder
if ! docker buildx ls | grep -q "multi-platform-builder"; then
    echo "🔧 Creating a new buildx builder for multi-platform support..."
    docker buildx create --name multi-platform-builder --use
fi

# Build and push multi-platform image (default)
echo "📦 Building multi-platform Docker image (amd64 & arm64)..."
docker buildx build --platform linux/amd64,linux/arm64 -t "$ECR_IMAGE" --push .

# Verify the built image manifest
echo "🔍 Verifying built image manifest..."
docker manifest inspect "$ECR_IMAGE" | jq '.manifests[].platform'

# OPTIONAL: Pull the correct architecture image (if needed for scanning)
if [ "$PULL_AFTER_BUILD" = "true" ]; then
    echo "📥 Pulling Docker image for $PLATFORM..."
    docker pull --platform "$PLATFORM" "$ECR_IMAGE"
fi

# Get image size in MB
IMAGE_SIZE=$(docker image inspect "$ECR_IMAGE" --format='{{.Size}}')
IMAGE_SIZE_MB=$((IMAGE_SIZE / 1024 / 1024))

echo "📏 Docker image size: ${IMAGE_SIZE_MB}MB"

# Enforce max image size of 500MB
if [ "$IMAGE_SIZE_MB" -gt 500 ]; then
    echo "❌ Error: Image size exceeds 500MB. Not pushing to ECR."
    exit 1
fi

echo "✅ Build and push completed successfully!"
