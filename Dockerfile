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
# chrome-paths package uses 'which' command to find browsers in this order:
# 1. google-chrome-stable (chrome branch - first priority)
# 2. google-chrome (chrome branch - second priority)
# 3. chromium-browser (canary branch)
# 4. chromium (canary branch)
RUN ln -s /usr/bin/chromium /usr/bin/google-chrome-stable && \
    ln -s /usr/bin/chromium /usr/bin/google-chrome && \
    ln -s /usr/bin/chromium /usr/bin/chromium-browser && \
    ln -s /usr/bin/chromium /usr/bin/chrome

# Configure Puppeteer and browser environment variables
# Add --no-sandbox for Docker container compatibility
# Set DISPLAY to prevent X server connection attempts
# CRITICAL: Add --headless=new to PUPPETEER_ARGS for browser_search provider
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    CHROME_BIN=/usr/bin/chromium \
    CHROME_PATH=/usr/bin/chromium \
    CHROMIUM_PATH=/usr/bin/chromium \
    CHROME_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_ARGS="--headless=new --no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu --disable-software-rasterizer" \
    DISPLAY=:99

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
# browser_search now works because we created google-chrome-stable symlink
CMD sh -c "agent-tars --ui --port 8080 \
  --config /app/mcp-config.ts \
  --workspace /app/workspace \
  --browser.control dom \
  --browser '{\"headless\":true,\"executablePath\":\"/usr/bin/chromium\",\"args\":[\"--headless=new\",\"--no-sandbox\",\"--disable-setuid-sandbox\",\"--disable-dev-shm-usage\",\"--disable-gpu\",\"--disable-software-rasterizer\"]}' \
  --search.provider browser_search \
  --search.count 10 \
  --model.provider ${TARS_MODEL_PROVIDER:-openai} \
  --model.id ${TARS_MODEL_NAME:-gpt-4o} \
  --model.baseURL ${TARS_MODEL_BASE_URL:-} \
  --model.apiKey ${TARS_MODEL_API_KEY:-${MODELSCOPE_API_KEY:-${DEEPSEEK_API_KEY:-${OPENAI_API_KEY:-${ANTHROPIC_API_KEY}}}}}"
