# Agent TARS CLI - Official Docker Deployment
FROM node:22-alpine

LABEL maintainer="jamesxie2025"
LABEL description="Agent TARS CLI - Multimodal AI Agent"

# Install system dependencies including build tools
RUN apk update && \
    apk add --no-cache \
    git \
    ca-certificates \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    python3 \
    make \
    g++ \
    && rm -rf /var/cache/apk/*

# Configure Puppeteer to use system Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Install Agent TARS CLI globally as root
RUN npm install -g @agent-tars/cli@latest

WORKDIR /app

# Create non-root user and set permissions
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    mkdir -p /app/data /app/cache /app/generated && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "console.log('healthy')" || exit 1

VOLUME ["/app/data", "/app/cache", "/app/generated"]

CMD ["agent-tars", "--ui", "--port", "8080"]
