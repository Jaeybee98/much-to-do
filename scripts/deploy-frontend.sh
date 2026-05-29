#!/bin/bash 
set -e

# Define deployment directories
BUILD_DIR="./Client/dist"
S3_BUCKET="starttech-frontend-app-jaeybee98"

echo "=================================================="
echo "📦 StartTech: Deploying Frontend Static Assets to S3"
echo "=================================================="

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Error: Production build directory '$BUILD_DIR' not found."
    echo "Please ensure 'npm run build' completes successfully within the pipeline."
    exit 1
fi

# Sync compiled production files to your AWS S3 bucket
echo "🚀 Syncing $BUILD_DIR with S3 bucket: s3://$S3_BUCKET..."
aws s3 sync "$BUILD_DIR" "s3://$S3_BUCKET" --delete

echo "✅ Frontend assets deployed successfully!"
# Triggering active pipeline deployment v1.0.2
