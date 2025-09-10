#!/bin/sh
# Railway-specific entrypoint for n8n

echo "🚂 Railway n8n Entrypoint"
echo "PORT provided by Railway: ${PORT}"

# Railway requires binding to 0.0.0.0:$PORT
if [ -z "$PORT" ]; then
  echo "⚠️ No PORT from Railway, using 5678"
  export PORT=5678
fi

echo "Starting n8n on 0.0.0.0:${PORT}"

# Start n8n with Railway's PORT
exec n8n start --host 0.0.0.0 --port ${PORT}