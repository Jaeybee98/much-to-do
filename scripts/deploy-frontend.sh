#!/bin/bash
set -e

# Configuration variables (Must match your S3 bucket from Phase 1)
BUCKET_NAME="starttech-frontend-app-jaeybee98"
DIST_DIR="./frontend/build"

echo "===================================================="
echo "📦 StartTech: Deploying Frontend Static Assets to S3"
echo "===================================================="

if [ ! -d "$DIST_DIR" ]; then
    echo "❌ Error: Production build directory '$DIST_DIR' not found."
    echo "Please ensure 'npm run build' completes successfully within the pipeline."
    exit 1
fi

echo "Step 1: Syncing compiled assets to AWS S3..."
aws s3 sync "$DIST_DIR" "s3://$BUCKET_NAME" --delete

echo "Step 2: Asset synchronization complete. Current bucket root:"
aws s3 ls "s3://$BUCKET_NAME"

echo "===================================================="
echo "🎉 Frontend assets successfully uploaded!"
echo "===================================================="
