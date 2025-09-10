FROM n8nio/n8n:latest

# Railway will set PORT at runtime
# n8n will use N8N_PORT and N8N_HOST from environment
ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main

# Start n8n directly
CMD ["n8n"]