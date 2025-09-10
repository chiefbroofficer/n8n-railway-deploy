# n8n Railway Deployment - Production Ready
FROM n8nio/n8n:latest

# Switch to root to install dependencies
USER root

# Install additional packages for database connections and utilities
RUN apk add --no-cache \
    postgresql-client \
    mysql-client \
    curl \
    bash \
    tzdata

# Create data directory with proper permissions
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Switch back to node user for security
USER node

# Set working directory
WORKDIR /home/node

# Railway uses dynamic PORT binding
EXPOSE ${PORT:-5678}

# Set environment variables for Railway
ENV N8N_HOST=0.0.0.0 \
    NODE_ENV=production \
    EXECUTIONS_PROCESS=main \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_PERSONALIZATION_ENABLED=false \
    GENERIC_TIMEZONE=America/New_York

# Remove healthcheck - Railway handles this differently
# Start n8n with Railway's PORT
CMD n8n start --port=${PORT:-5678}