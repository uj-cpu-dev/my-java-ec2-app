#!/bin/bash
set -e
echo "Deploying application with Helm..."
IMAGE_TAG=$(cat image-tag.txt)
helm upgrade --install my-app ./my-app \
    --namespace $NAMESPACE \
    --set image.repository=$ECR_REGISTRY/$REPO_NAME \
    --set image.tag=$IMAGE_TAG \
    --set image.pullPolicy=IfNotPresent \
    --kubeconfig ~/.kube/config
