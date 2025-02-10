#!/bin/bash
set -e  # Exit on error

echo "🚀 Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)
ECR_IMAGE="$ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG"

# Build the image locally
echo "📦 Building Docker image..."
docker build -t "$ECR_IMAGE" .

# Get image size in MB
IMAGE_SIZE=$(docker image inspect "$ECR_IMAGE" --format='{{.Size}}' || echo "0")
IMAGE_SIZE_MB=$((IMAGE_SIZE / 1024 / 1024))

echo "📏 Docker image size: ${IMAGE_SIZE_MB}MB"

# Enforce max image size of 500MB before pushing
if [ "$IMAGE_SIZE_MB" -gt 500 ]; then
    echo "❌ Error: Image size exceeds 500MB. Not pushing to ECR."
    exit 1
fi

# Push the image to ECR
echo "📤 Pushing Docker image to ECR..."
docker push "$ECR_IMAGE"

echo "✅ Build and push completed successfully!"