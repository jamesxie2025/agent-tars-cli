# Agent TARS CLI - Official Docker Deployment
# Using Debian-based image for better compatibility
FROM node:22-slim

LABEL maintainer="jamesxie2025"
LABEL description="Agent TARS CLI - Multimodal AI Agent"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    chromium \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Configure Puppeteer to use system Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    CHROME_BIN=/usr/bin/chromium \
    CHROME_PATH=/usr/bin/chromium

# Install Agent TARS CLI globally as root
RUN npm install -g @agent-tars/cli@latest

WORKDIR /app

# Create non-root user and set permissions
RUN groupadd -g 1001 nodejs && \
    useradd -u 1001 -g nodejs -s /bin/bash -m nodejs && \
    mkdir -p /app/data /app/cache /app/generated && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "console.log('healthy')" || exit 1

VOLUME ["/app/data", "/app/cache", "/app/generated"]

# Start Agent TARS with model configuration from environment variables
# Use shell form to allow environment variable substitution
CMD sh -c "agent-tars --ui --port 8080 --provider ${TARS_MODEL_PROVIDER:-modelscope} --model ${TARS_MODEL_NAME:-qwen-max} --apiKey ${MODELSCOPE_API_KEY:-${DEEPSEEK_API_KEY:-${OPENAI_API_KEY:-${ANTHROPIC_API_KEY}}}}"
