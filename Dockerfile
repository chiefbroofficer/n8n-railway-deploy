FROM n8nio/n8n:latest

USER root

# Install dependencies
RUN apk add --no-cache postgresql-client

# Copy entrypoint
COPY --chown=node:node entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER node

# Set environment
ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main

# Use entrypoint
ENTRYPOINT ["/entrypoint.sh"]