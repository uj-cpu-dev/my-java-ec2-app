#!/bin/bash
set -e
echo "Building Docker image..."
IMAGE_TAG=$(cat image-tag.txt)
docker build --platform linux/amd64 -t $REPO_NAME:$IMAGE_TAG .
docker tag $REPO_NAME:$IMAGE_TAG $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG
echo "Pushing Docker image to ECR..."
docker push $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG