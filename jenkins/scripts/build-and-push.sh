#!/bin/bash
set -e  # Exit on error

echo "🚀 Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)
ECR_IMAGE="$ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG"

# Enable Docker BuildKit
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1

# Check if buildx exists, else create a new builder
if ! docker buildx ls | grep -q "multi-platform-builder"; then
    echo "🔧 Creating a new buildx builder for multi-platform support..."
    docker buildx create --name multi-platform-builder --use
fi

# Build and push multi-platform image
echo "📦 Building and pushing multi-platform Docker image (amd64 & arm64)..."
docker buildx build --platform linux/amd64,linux/arm64 -t "$ECR_IMAGE" --push .

# Wait a few seconds for ECR to process the image
sleep 10  

# Verify the built image manifest
echo "🔍 Verifying built image manifest..."
docker manifest inspect "$ECR_IMAGE" | jq '.manifests[].platform' || {
    echo "❌ Error: Image manifest verification failed!"
    exit 1
}

# Ensure the manifest is correctly created (fallback)
echo "📌 Creating multi-platform manifest in case of missing entries..."
docker manifest create "$ECR_IMAGE" \
    --amend "$ECR_IMAGE-amd64" \
    --amend "$ECR_IMAGE-arm64"

# Push the updated manifest to ECR
docker manifest push "$ECR_IMAGE"

# Get image size in MB
IMAGE_SIZE=$(docker image inspect "$ECR_IMAGE" --format='{{.Size}}' || echo "0")
IMAGE_SIZE_MB=$((IMAGE_SIZE / 1024 / 1024))

echo "📏 Docker image size: ${IMAGE_SIZE_MB}MB"

# Enforce max image size of 500MB
if [ "$IMAGE_SIZE_MB" -gt 500 ]; then
    echo "❌ Error: Image size exceeds 500MB. Not pushing to ECR."
    exit 1
fi

echo "✅ Build and push completed successfully!"