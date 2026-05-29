# StartTech Full-Stack Application Operations Runbook

This runbook provides instructional procedures for monitoring, diagnosing, and resolving production incidents across the MuchTodo full-stack stack.

---

## 🚨 Incident Triage Tier 1: ALB Health Check Failures
**Symptom:** Automated pipeline health-checks fail with `HTTP 502 Bad Gateway` or timeouts on the `/health` endpoint.

### Action Plan:
1. **Verify Target Group Registration Status:** Log into the AWS console, navigate to **EC2 -> Target Groups**, and check if the backend instances are showing as `Unhealthy`.
2. **Access Live Instance Logs:** Run a CloudWatch Log Insights query to inspect runtime panics:
   ```text
   fields @timestamp, @message | filter level = "error" | sort @timestamp desc

Manual Rollback Procedure: If the automated pipeline script (rollback.sh) fails to trigger, SSH directly into the affected backend instance and run:
docker stop much-to-do-backend || true
docker run -d --name much-to-do-backend -p 8080:8080 -e MONGO_URI="<uri>" -e REDIS_HOST="<host>" much-to-do-backend:previous

💾 Incident Triage Tier 2: Database Connection Lost
Symptom: Backend log streams return context deadline exceeded or connection refused patterns targeting MongoDB Atlas.

Action Plan:
Inspect Network Access Firewalls: Confirm that the MongoDB Atlas Network Access panel allows communication from anywhere (0.0.0.0/0) since your EC2 instances launch dynamically inside changing private IP ranges.

Verify Secret String Integrity: Check GitHub Secrets to ensure MONGO_URI is accurately formed without hidden carriage return characters or typos.

⚡ Incident Triage Tier 3: Frontend Asset Delivery Stale
Symptom: Newly pushed features on the React application do not render for end-users visiting the web client.

Action Plan:
Manual Cache Invalidation: CloudFront edge locations cache components for up to 24 hours by default. If the pipeline step skips invalidation, force it using the AWS CLI:
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID_HERE --paths "/*"

