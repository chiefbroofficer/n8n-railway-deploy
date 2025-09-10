# Ultra-simple n8n for Railway
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

USER node
WORKDIR /home/node

# Railway provides PORT
EXPOSE ${PORT}

# Minimal config - let environment variables handle everything
CMD n8n start