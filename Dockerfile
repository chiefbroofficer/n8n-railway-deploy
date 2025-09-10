# n8n for Railway - Fixed with shell expansion
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

USER node
WORKDIR /home/node

# Set n8n to listen on all interfaces
ENV N8N_LISTEN_ADDRESS=0.0.0.0
ENV N8N_HOST=0.0.0.0

# Railway provides PORT dynamically
EXPOSE 5678

# CRITICAL: Use /bin/sh -c to expand PORT variable per Railway docs
CMD ["/bin/sh", "-c", "n8n start --port=${PORT:-5678}"]