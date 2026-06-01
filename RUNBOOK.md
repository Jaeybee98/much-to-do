# StartTech Operations & Troubleshooting Runbook

## Automated CI/CD Lifecycle
* **Frontend:** Pushing code triggers `.github/workflows/frontend-ci-cd.yml`, building static assets and syncing directly to AWS S3.
* **Backend:** Pushing code triggers `.github/workflows/backend-ci-cd.yml`, checking code quality, compiling a production Docker image, and pushing to Amazon ECR. 

## Common Operational Fixes

### 1. Re-deploying / Upstream Image Rotation
If instances need a manual force pull of a fresh container image from ECR, trigger an ASG Instance Refresh via the AWS CLI:
```bash
aws autoscaling start-instance-refresh --auto-scaling-group-name starttech-asg --region us-east-1
