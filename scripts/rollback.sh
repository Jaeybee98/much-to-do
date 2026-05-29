#!/bin/bash
set -e

APP_NAME="much-to-do-backend"

echo "===================================================="
echo "🚨 Critical Alert: Executing Automated Rollback Loop"
echo "===================================================="

if [ "$(docker images -q ${APP_NAME}:previous 2> /dev/null)" ]; then
    echo "Step 1: Tearing down broken application version container..."
    docker stop "$APP_NAME" || true
    docker rm "$APP_NAME" || true
    
    echo "Step 2: Restoring stable previous container instance..."
    docker run -d \
      --name "$APP_NAME" \
      --restart unless-stopped \
      -p 8080:8080 \
      -e MONGO_URI="$MONGO_URI" \
      -e REDIS_HOST="$REDIS_HOST" \
      -e PORT="8080" \
      "${APP_NAME}:previous"
      
    echo "✅ Rollback strategy execution completed!"
else
    echo "❌ System Error: No backup container snapshot verified found on disk server."
    exit 1
fi
echo "===================================================="
