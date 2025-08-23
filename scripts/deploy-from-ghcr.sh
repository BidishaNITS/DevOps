#!/usr/bin/env bash
set -euo pipefail

IMAGE="ghcr.io/bidishanits/app:latest"

echo "Updating deployment to image: ${IMAGE}"
kubectl set image deployment/app-deployment myapp="${IMAGE}"
kubectl rollout status deployment/app-deployment
echo "Done. Open the app with: minikube service app-service"
