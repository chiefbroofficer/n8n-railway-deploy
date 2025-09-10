FROM n8nio/n8n:latest

# Railway will set PORT at runtime
ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main
ENV N8N_HOST=0.0.0.0

# Create a startup script that uses Railway's PORT
RUN echo '#!/bin/sh\nexport N8N_PORT=${PORT:-5678}\necho "Starting n8n on port $N8N_PORT"\nn8n' > /start.sh && \
    chmod +x /start.sh

# Use the startup script
CMD ["/start.sh"]