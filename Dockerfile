# Ultra-simple n8n for Railway
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

USER node
WORKDIR /home/node

# Railway provides PORT
EXPOSE ${PORT}

# Minimal config - let environment variables handle everything
# Must explicitly bind to 0.0.0.0 and use Railway's PORT
CMD ["sh", "-c", "n8n start --port=${PORT:-5678}"]