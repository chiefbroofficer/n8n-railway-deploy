# n8n for Railway with entrypoint
FROM n8nio/n8n:latest

# Copy and set up entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Railway requires listening on 0.0.0.0
ENV N8N_HOST=0.0.0.0

# Use entrypoint for PORT handling
ENTRYPOINT ["/entrypoint.sh"]