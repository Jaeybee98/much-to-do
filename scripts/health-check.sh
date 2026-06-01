#!/bin/bash

# Check if ALB DNS is passed as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <load-balancer-dns-name>"
    exit 1
fi

ALB_DNS=$1
HEALTH_URL="http://${ALB_DNS}:8080/health"

echo "Checking backend health at: ${HEALTH_URL}"

# Retry loop (checks 5 times with a 5-second delay)
for i in {1..5}; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${HEALTH_URL}")
    if [ "$RESPONSE" -eq 200 ]; then
        echo "✅ Health check PASSED! Backend is responding with HTTP 200."
        exit 0
    else
        echo "⚠️ Attempt $i: Backend responded with HTTP ${RESPONSE}. Retrying..."
        sleep 5
    fi
done

echo "❌ Health check FAILED! Backend is unreachable."
exit 1
