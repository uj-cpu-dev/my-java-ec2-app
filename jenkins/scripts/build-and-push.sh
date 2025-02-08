#!/bin/bash
set -e

# Ensure Trivy is installed
if ! command -v trivy &> /dev/null; then
    echo "Trivy is not installed or not in PATH. Exiting."
    exit 1
fi

# Define a shared Trivy cache directory
export TRIVY_CACHE_DIR=/var/lib/trivy
mkdir -p $TRIVY_CACHE_DIR
sudo chown -R jenkins:jenkins $TRIVY_CACHE_DIR

# Ensure Trivy database exists
if [ ! -f "$TRIVY_CACHE_DIR/db/trivy.db" ]; then
    echo "Trivy database not found. Downloading..."
    trivy --cache-dir $TRIVY_CACHE_DIR image --download-db-only --db-repository ghcr.io/aquasecurity/trivy-db
fi

echo "Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)

# Build image
docker build -t $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG .

# Scan the image using the pre-downloaded database
echo "Scanning Docker image for vulnerabilities..."
trivy --cache-dir $TRIVY_CACHE_DIR image --skip-db-update $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

if [ $? -eq 1 ]; then
    echo "Image scanning failed due to HIGH or CRITICAL vulnerabilities."
    exit 1
fi

echo "Pushing Docker image to ECR..."
docker push $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG
