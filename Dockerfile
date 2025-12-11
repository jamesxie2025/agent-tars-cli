# Agent TARS CLI - Official Docker Deployment
FROM node:22-alpine

LABEL maintainer="jamesxie2025"

# Install system dependencies
RUN apk add --no-cache chromium nss freetype harfbuzz ca-certificates ttf-freefont git

# Configure Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001 && \
    mkdir -p /app/data /app/cache /app/generated && chown -R nodejs:nodejs /app

USER nodejs

# Install Agent TARS CLI
RUN npm install -g @agent-tars/cli@latest

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "console.log('healthy')" || exit 1

VOLUME ["/app/data", "/app/cache", "/app/generated"]

CMD ["agent-tars", "--ui", "--port", "8080"]
