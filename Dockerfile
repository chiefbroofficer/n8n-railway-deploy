# Ultra-simple n8n for Railway
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

USER node
WORKDIR /home/node

# Railway provides PORT
EXPOSE ${PORT}

# n8n will use N8N_PORT and N8N_LISTEN_ADDRESS from environment
CMD ["n8n", "start"]