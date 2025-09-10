# n8n for Railway - Based on official docs
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

USER node
WORKDIR /home/node

# Set n8n to listen on all interfaces
ENV N8N_LISTEN_ADDRESS=0.0.0.0

# Railway provides PORT dynamically - we'll override at runtime
EXPOSE 5678

# Start n8n with dynamic PORT from Railway
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["n8n start --port=${PORT:-5678}"]