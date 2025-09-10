# n8n for Railway - Enhanced with debugging
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

# Copy startup script
COPY --chown=node:node startup.sh /home/node/startup.sh
RUN chmod +x /home/node/startup.sh

USER node
WORKDIR /home/node

# Set n8n to listen on all interfaces
ENV N8N_LISTEN_ADDRESS=0.0.0.0
ENV N8N_HOST=0.0.0.0

# Railway provides PORT dynamically
EXPOSE 5678

# Use enhanced startup script for better debugging
CMD ["/home/node/startup.sh"]