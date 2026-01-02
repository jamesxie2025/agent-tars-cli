#!/bin/bash

# Test ModelScope API connectivity
# This script tests if the ModelScope API is responding correctly

set -e

echo "🧪 Testing ModelScope API..."
echo ""

# Load environment variables
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    exit 1
fi

export $(grep -v '^#' .env | xargs)
API_KEY=$(grep MODELSCOPE_API_KEY .env | cut -d'=' -f2)

echo "📋 Configuration:"
echo "  - API Key: ${API_KEY:0:10}..."
echo "  - Base URL: https://api-inference.modelscope.cn/v1"
echo "  - Model: Qwen/Qwen3-Coder-480B-A35B-Instruct"
echo ""

echo "🔍 Testing API connection..."
echo ""

# Test API with a simple request
curl -X POST "https://api-inference.modelscope.cn/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "Qwen/Qwen3-Coder-480B-A35B-Instruct",
    "messages": [
      {
        "role": "user",
        "content": "Hello, respond with just OK"
      }
    ],
    "max_tokens": 10,
    "temperature": 0.7
  }' \
  --max-time 30 \
  --connect-timeout 10 \
  -w "\n\n⏱️  Time: %{time_total}s\n" \
  -v

echo ""
echo "✅ API test completed"

