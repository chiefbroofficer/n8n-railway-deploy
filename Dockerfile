# Ultra-simple n8n for Railway
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

# Copy and setup startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

USER node
WORKDIR /home/node

# Railway provides PORT dynamically
EXPOSE 5678

# Use shell form to allow variable expansion
CMD ["/bin/sh", "-c", "N8N_PORT=${PORT:-5678} N8N_LISTEN_ADDRESS=0.0.0.0 n8n start"]