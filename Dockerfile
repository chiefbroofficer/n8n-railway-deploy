FROM n8nio/n8n:latest

# Set environment variables
ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main
ENV N8N_HOST=0.0.0.0
ENV WEBHOOK_URL=https://n8n-railway-deploy-production-1b25.up.railway.app/

# Use shell form to allow environment variable expansion
CMD n8n start --port ${PORT:-5678}