FROM n8nio/n8n:latest

# Set environment variables
ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main
ENV N8N_HOST=0.0.0.0
ENV WEBHOOK_URL=https://n8n-railway-deploy-production-1b25.up.railway.app/

# Use ENTRYPOINT with sh -c to ensure PORT is properly set
ENTRYPOINT ["/bin/sh", "-c", "export N8N_PORT=${PORT:-5678} && echo 'Starting n8n on port' $N8N_PORT && exec n8n start"]