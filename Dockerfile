# Ultra-simple n8n for Railway
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache postgresql-client

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

USER node
WORKDIR /home/node

# Railway provides PORT
EXPOSE ${PORT}

# Use startup script for proper port binding
CMD ["/startup.sh"]