#!/bin/sh

# Railway provides PORT as environment variable
echo "Starting n8n..."
echo "PORT environment variable: ${PORT}"
echo "N8N_HOST: ${N8N_HOST}"
echo "N8N_PORT: ${N8N_PORT}"

# Ensure PORT is set
if [ -z "$PORT" ]; then
    echo "PORT not set, using default 5678"
    export PORT=5678
fi

echo "Starting n8n on 0.0.0.0:${PORT}"

# Start n8n with explicit port binding
exec n8n start --host 0.0.0.0 --port ${PORT}