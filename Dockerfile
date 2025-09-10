FROM n8nio/n8n:latest

ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main
ENV N8N_HOST=0.0.0.0

# Create a simple entrypoint script inline
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'export N8N_PORT=${PORT:-5678}' >> /start.sh && \
    echo 'export N8N_HOST=0.0.0.0' >> /start.sh && \
    echo 'echo "Starting n8n on port $N8N_PORT"' >> /start.sh && \
    echo 'exec tini -- /docker-entrypoint.sh n8n start' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]