# n8n for Railway - Simple approach
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

# Add start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER node
WORKDIR /home/node

# Set n8n to listen on all interfaces
ENV N8N_LISTEN_ADDRESS=0.0.0.0
ENV N8N_HOST=0.0.0.0

# Railway provides PORT dynamically
EXPOSE 5678

# Use the start script
CMD ["/start.sh"]