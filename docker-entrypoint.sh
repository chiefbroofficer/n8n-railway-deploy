#!/bin/sh

# Set n8n port from Railway's PORT environment variable
if [ -n "$PORT" ]; then
    echo "Setting N8N_PORT to Railway's PORT: $PORT"
    export N8N_PORT=$PORT
else
    echo "Warning: PORT not set, using default 5678"
    export N8N_PORT=5678
fi

# Ensure N8N_HOST is set for proper binding
export N8N_HOST=0.0.0.0

# Debug output
echo "Starting n8n with:"
echo "  N8N_PORT=$N8N_PORT"
echo "  N8N_HOST=$N8N_HOST"
echo "  N8N_PROTOCOL=$N8N_PROTOCOL"

# Execute the original n8n entrypoint
exec tini -- /docker-entrypoint.sh n8n start