#!/bin/bash
set -e

# Function to install Trivy
install_trivy() {
    echo "Installing Trivy..."

    # Step 1: Get the latest Trivy version
    TRIVY_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    echo "Latest Trivy version: $TRIVY_VERSION"

    # Step 2: Download the Trivy binary
    echo "Downloading Trivy binary..."
    curl -LO https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

    # Step 3: Extract the binary
    echo "Extracting Trivy binary..."
    tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

    # Step 4: Move the binary to /usr/local/bin
    echo "Moving Trivy binary to /usr/local/bin..."
    sudo mv trivy /usr/local/bin/

    # Step 5: Clean up
    echo "Cleaning up..."
    rm trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

    # Step 6: Verify the installation
    echo "Verifying Trivy installation..."
    trivy --version

    if [ $? -eq 0 ]; then
        echo "Trivy installed successfully."
    else
        echo "Failed to install Trivy."
        exit 1
    fi
}

# Check if Trivy is installed, else install it
if ! command -v trivy &> /dev/null; then
    install_trivy
fi

echo "Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)

# Enable experimental feature for multi-platform builds if using Docker BuildKit
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1

# Check if buildx exists, else create a new builder
if ! docker buildx ls | grep -q "multi-platform-builder"; then
    echo "Creating a new buildx builder for multi-platform support..."
    docker buildx create --name multi-platform-builder --use
fi

# Build multi-platform image
docker buildx build --platform linux/amd64,linux/arm64 -t $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG --push .

# Scan image for vulnerabilities
echo "Scanning Docker image for vulnerabilities..."
export TRIVY_CACHE_DIR=/var/lib/jenkins/trivy-cache
mkdir -p $TRIVY_CACHE_DIR

# Update DB first
trivy --cache-dir $TRIVY_CACHE_DIR image --download-db-only

# Scan the image without updating the DB
trivy image --scanners vuln --skip-db-update --cache-dir $TRIVY_CACHE_DIR --no-progress --timeout 5m $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

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