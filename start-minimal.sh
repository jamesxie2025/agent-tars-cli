#!/bin/bash

# Agent TARS CLI Startup Script - Minimal Configuration
# This script starts Agent TARS with minimal MCP servers to avoid timeout issues

set -e

echo "🚀 Starting Agent TARS CLI (Minimal Configuration)..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed"
    echo "Please install Node.js 18+ from https://nodejs.org/"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Error: Node.js version must be 18 or higher"
    echo "Current version: $(node -v)"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo ""
    echo "Please create .env file with your API keys:"
    echo "  1. Copy from a template: cp .env.local.qwen .env"
    echo "  2. Or copy from example: cp .env.example .env"
    echo "  3. Then edit .env and add your real API keys"
    echo ""
    exit 1
fi

ENV_FILE=.env
echo "📝 Using .env for configuration"
echo "⚡ Using minimal configuration (faster startup, fewer features)"

# Create necessary directories
mkdir -p cache data workspace

# Check if @agent-tars/cli is installed
if [ ! -d "node_modules/@agent-tars/cli" ]; then
    echo "📦 Installing @agent-tars/cli..."
    npm install
    echo ""
fi

# Load environment variables
export $(grep -v '^#' $ENV_FILE | xargs)

# Extract model configuration
MODEL_PROVIDER=$(grep TARS_MODEL_PROVIDER $ENV_FILE | cut -d'=' -f2)
MODEL_NAME=$(grep TARS_MODEL_NAME $ENV_FILE | cut -d'=' -f2)
MODEL_BASE_URL=$(grep TARS_MODEL_BASE_URL $ENV_FILE | cut -d'=' -f2)
MODEL_API_KEY=$(grep TARS_MODEL_API_KEY $ENV_FILE | cut -d'=' -f2 | envsubst)

# Display configuration
echo ""
echo "📋 Configuration:"
echo "  - Model: $MODEL_NAME"
echo "  - Provider: $MODEL_PROVIDER"
echo "  - Base URL: $MODEL_BASE_URL"
echo "  - Config: agent.config.minimal.ts"
echo "  - Port: 8888 (default)"
echo ""

# Start Agent TARS
echo "✅ Starting Agent TARS..."
echo "   Web UI: http://localhost:8888"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Set Node.js environment variables for better timeout handling
export NODE_OPTIONS="--max-old-space-size=4096"

# Start Agent TARS with minimal configuration
npx agent-tars start \
  --config agent.config.minimal.ts \
  --model.provider "$MODEL_PROVIDER" \
  --model.id "$MODEL_NAME" \
  --model.baseURL "$MODEL_BASE_URL" \
  --model.apiKey "$MODEL_API_KEY" \
  --workspace "./workspace" \
  --stream \
  --debug

