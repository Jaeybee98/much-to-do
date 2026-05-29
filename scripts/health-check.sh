#!/bin/bash
set -e

# Target parameters passed from pipeline execution
ALB_URL=$1
MAX_ATTEMPTS=5
TIMEOUT=10

echo "===================================================="
echo "🔍 Automated Health Check: Validating ALB Endpoints"
echo "===================================================="

if [ -z "$ALB_URL" ]; then
    echo "❌ Error: Missing target Load Balancer address string argument."
    exit 1
fi

for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
    echo "Attempt $attempt of $MAX_ATTEMPTS: Querying http://${ALB_URL}/health..."
    
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "http://${ALB_URL}/health" || true)
    
    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "✅ Success! Backend API status returned HTTP 200 OK."
        echo "===================================================="
        exit 0
    fi
    
    echo "⚠️ Target returned status code: $STATUS_CODE. Retrying in 15 seconds..."
    sleep 15
done

echo "❌ Critical Failure: ALB target groups failed to resolve healthy status thresholds."
echo "===================================================="
exit 1
