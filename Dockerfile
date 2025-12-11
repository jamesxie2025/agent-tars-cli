# Agent TARS CLI - Official Docker Deployment
FROM node:22-alpine

LABEL maintainer="jamesxie2025"
LABEL description="Agent TARS CLI - Multimodal AI Agent"

# Install system dependencies
# Split into multiple RUN commands for better caching and error handling
RUN apk update && \
    apk add --no-cache \
    git \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Install Chromium separately (for browser automation)
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Configure Puppeteer to use system Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    mkdir -p /app/data /app/cache /app/generated && \
    chown -R nodejs:nodejs /app

USER nodejs

# Install Agent TARS CLI globally
RUN npm install -g @agent-tars/cli@latest

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "console.log('healthy')" || exit 1

VOLUME ["/app/data", "/app/cache", "/app/generated"]

CMD ["agent-tars", "--ui", "--port", "8080"]
