# n8n Railway Deployment - Production Ready
FROM n8nio/n8n:latest

# Switch to root to install dependencies
USER root

# Install additional packages for database connections and utilities
RUN apk add --no-cache \
    postgresql-client \
    mysql-client \
    redis \
    curl \
    bash \
    jq \
    tzdata

# Create data directory with proper permissions
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Switch back to node user for security
USER node

# Set working directory
WORKDIR /home/node

# Expose n8n port
EXPOSE 5678

# Health check to ensure n8n is running
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Set default environment variables for Railway
ENV N8N_HOST=0.0.0.0 \
    N8N_PORT=5678 \
    N8N_PROTOCOL=https \
    N8N_BASIC_AUTH_ACTIVE=true \
    NODE_ENV=production \
    EXECUTIONS_PROCESS=main \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_PERSONALIZATION_ENABLED=false \
    N8N_VERSION_NOTIFICATIONS_ENABLED=true \
    N8N_METRICS=false \
    GENERIC_TIMEZONE=America/New_York

# Start n8n
CMD ["n8n", "start"]