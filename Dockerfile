# Agent TARS CLI - Official Docker Deployment
# Using Debian-based image for better compatibility
FROM node:22-slim

LABEL maintainer="jamesxie2025"
LABEL description="Agent TARS CLI - Multimodal AI Agent"

# Install system dependencies including Python for data processing
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    python3 \
    python3-pip \
    python3-venv \
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

# Install Python packages for data processing and visualization
RUN pip3 install --no-cache-dir --break-system-packages \
    pandas \
    openpyxl \
    xlrd \
    matplotlib \
    seaborn \
    plotly \
    numpy

# Create Chrome symlinks for Agent TARS browser detection
# chrome-paths package checks these specific locations on Linux
RUN ln -s /usr/bin/chromium /usr/bin/google-chrome && \
    ln -s /usr/bin/chromium /usr/bin/chrome && \
    mkdir -p /opt/google/chrome && \
    ln -s /usr/bin/chromium /opt/google/chrome/chrome && \
    ln -s /usr/bin/chromium /opt/google/chrome/google-chrome

# Configure Puppeteer and browser environment variables
# Add --no-sandbox for Docker container compatibility
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    CHROME_BIN=/usr/bin/chromium \
    CHROME_PATH=/usr/bin/chromium \
    CHROMIUM_PATH=/usr/bin/chromium \
    CHROME_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage"

# Install Agent TARS CLI globally as root
RUN npm install -g @agent-tars/cli@latest

WORKDIR /app

# Create non-root user and set permissions
RUN groupadd -g 1001 nodejs && \
    useradd -u 1001 -g nodejs -s /bin/bash -m nodejs && \
    mkdir -p /app/data /app/cache /app/generated /app/workspace && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "console.log('healthy')" || exit 1

VOLUME ["/app/data", "/app/cache", "/app/generated", "/app/workspace"]

# Start Agent TARS with model configuration from environment variables
# Use shell form to allow environment variable substitution
# Explicitly specify browser executable path and args for Docker compatibility
# Note: browser_search provider doesn't work in Docker due to browser path detection issues
# Users should use browser navigation tools (browser_navigate, browser_get_markdown) for web search
CMD sh -c "agent-tars --ui --port 8080 \
  --config /app/mcp-config.ts \
  --workspace /app/workspace \
  --browser.control dom \
  --browser '{\"executablePath\":\"/usr/bin/chromium\",\"args\":[\"--no-sandbox\",\"--disable-setuid-sandbox\",\"--disable-dev-shm-usage\",\"--disable-gpu\"]}' \
  --model.provider ${TARS_MODEL_PROVIDER:-openai} \
  --model.id ${TARS_MODEL_NAME:-gpt-4o} \
  --model.baseURL ${TARS_MODEL_BASE_URL:-} \
  --model.apiKey ${TARS_MODEL_API_KEY:-${MODELSCOPE_API_KEY:-${DEEPSEEK_API_KEY:-${OPENAI_API_KEY:-${ANTHROPIC_API_KEY}}}}}"
