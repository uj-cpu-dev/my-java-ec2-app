#!/bin/bash
set -e
echo "Performing health check..."
kubectl rollout status deployment/my-app -n $NAMESPACE