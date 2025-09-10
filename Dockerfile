FROM n8nio/n8n:latest

USER root

# Install dependencies
RUN apk add --no-cache postgresql-client

# Copy entrypoint
COPY --chown=node:node entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER node

# Set environment
ENV N8N_HOST=0.0.0.0
ENV NODE_ENV=production

# Use entrypoint
ENTRYPOINT ["/entrypoint.sh"]