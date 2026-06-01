#!/bin/bash

ASG_NAME="starttech-asg"
REGION="us-east-1"

echo "🚨 Initiating deployment rollback for ${ASG_NAME}..."

# Find the previous launch template version (Version 1)
echo "🔄 Reverting Auto Scaling Group to stable template Version 1..."
aws ec2 update-auto-scaling-group \
    --auto-scaling-group-name "$ASG_NAME" \
    --launch-template "LaunchTemplateName=starttech-lt-20260529205943823000000004,Version=1" \
    --region "$REGION"

# Trigger a fresh instance refresh to replace running containers with the stable version
echo "🔄 Triggering Instance Refresh to roll back active nodes..."
aws autoscaling start-instance-refresh \
    --auto-scaling-group-name "$ASG_NAME" \
    --region "$REGION"

echo "✅ Rollback triggered successfully. Monitor the AWS Console for node rotation."
