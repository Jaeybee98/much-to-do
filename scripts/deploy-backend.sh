#!/bin/bash
set -e

echo "===================================================="
echo "🚀 StartTech: Initiating Backend Container Deployment"
echo "===================================================="

# Application Variables
APP_NAME="much-to-do-backend"
AWS_ACCOUNT_ID="123456789012" # Handled dynamically inside GitHub secrets
REGISTRY_URL="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
IMAGE_TAG="latest"

echo "Step 1: Authenticating Docker with AWS ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$REGISTRY_URL"

echo "Step 2: Pulling fresh Docker image container..."
docker pull "${REGISTRY_URL}/${APP_NAME}:${IMAGE_TAG}"

echo "Step 3: Safeguarding old deployment states..."
if [ "$(docker ps -aq -f name=${APP_NAME})" ]; then
    echo "Stopping existing backend server context..."
    docker stop "$APP_NAME" || true
    docker rm "$APP_NAME" || true
fi

echo "Step 4: Launching new application version runtime..."
# Deploys application and mounts runtime context mapping variables
docker run -d \
  --name "$APP_NAME" \
  --restart unless-stopped \
  -p 8080:8080 \
  -e MONGO_URI="$MONGO_URI" \
  -e REDIS_HOST="$REDIS_HOST" \
  -e PORT="8080" \
  "${REGISTRY_URL}/${APP_NAME}:${IMAGE_TAG}"

echo "===================================================="
echo "✅ Container deployment successfully executed!"
echo "===================================================="
