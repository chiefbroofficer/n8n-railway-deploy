FROM n8nio/n8n:latest

ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main

# Copy custom entrypoint script
COPY docker-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# Use our custom entrypoint that sets PORT
ENTRYPOINT ["/custom-entrypoint.sh"]