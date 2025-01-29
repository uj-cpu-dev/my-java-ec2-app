#!/bin/bash
set -e
echo "Setting image tag..."
GIT_COMMIT_HASH=$(git rev-parse HEAD)
SHORT_HASH=${GIT_COMMIT_HASH:0:7}
IMAGE_TAG="feature-branch-${SHORT_HASH}"
echo "$IMAGE_TAG" > image-tag.txt
echo "Image tag is set to: $IMAGE_TAG"