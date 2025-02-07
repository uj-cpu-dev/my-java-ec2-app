#!/bin/bash
set -e
echo "Configuring Kubernetes access and Helm..."
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm version || curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash