#!/bin/sh
# Railway-specific entrypoint for n8n

echo "🚂 Railway n8n Entrypoint"
echo "PORT provided by Railway: ${PORT}"

# Railway requires binding to 0.0.0.0:$PORT
if [ -z "$PORT" ]; then
  echo "⚠️ No PORT from Railway, using 5678"
  export PORT=5678
fi

# Set n8n environment variables
export N8N_PORT=${PORT}
export N8N_HOST=0.0.0.0

echo "Starting n8n on ${N8N_HOST}:${N8N_PORT}"

# Start n8n (it will use N8N_HOST and N8N_PORT from environment)
exec n8n