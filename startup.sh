#!/bin/sh
# Enhanced n8n startup script for Railway with comprehensive debugging

echo "🚀 n8n Railway Startup Script v2.0"
echo "=================================="
date

# Log all relevant environment variables
echo ""
echo "📊 Environment Variables:"
echo "  PORT=${PORT}"
echo "  N8N_PORT=${N8N_PORT}"
echo "  N8N_HOST=${N8N_HOST}"
echo "  N8N_LISTEN_ADDRESS=${N8N_LISTEN_ADDRESS}"
echo "  NODE_ENV=${NODE_ENV}"
echo "  DB_TYPE=${DB_TYPE}"
echo "  N8N_PROTOCOL=${N8N_PROTOCOL}"
echo "  WEBHOOK_URL=${WEBHOOK_URL}"

# Determine which port to use
if [ -n "$PORT" ]; then
    ACTUAL_PORT=$PORT
    echo ""
    echo "✅ Using Railway PORT: $ACTUAL_PORT"
elif [ -n "$N8N_PORT" ]; then
    ACTUAL_PORT=$N8N_PORT
    echo ""
    echo "⚠️ Railway PORT not set, using N8N_PORT: $ACTUAL_PORT"
else
    ACTUAL_PORT=5678
    echo ""
    echo "⚠️ No PORT specified, using default: $ACTUAL_PORT"
fi

# Database connection test
if [ "$DB_TYPE" = "postgresdb" ]; then
    echo ""
    echo "🗄️ Database Configuration:"
    echo "  Host: ${DB_POSTGRESDB_HOST}"
    echo "  Port: ${DB_POSTGRESDB_PORT}"
    echo "  Database: ${DB_POSTGRESDB_DATABASE}"
    echo "  User: ${DB_POSTGRESDB_USER}"
    
    # Test database connectivity
    if command -v pg_isready >/dev/null 2>&1; then
        echo "  Testing connection..."
        pg_isready -h "$DB_POSTGRESDB_HOST" -p "$DB_POSTGRESDB_PORT" -U "$DB_POSTGRESDB_USER" -d "$DB_POSTGRESDB_DATABASE" -t 5 && echo "  ✅ Database reachable" || echo "  ⚠️ Database not reachable"
    fi
fi

# Log startup command
echo ""
echo "🎯 Starting n8n with:"
echo "  Host: 0.0.0.0"
echo "  Port: $ACTUAL_PORT"
echo "  Command: n8n start --host 0.0.0.0 --port $ACTUAL_PORT"
echo "=================================="
echo ""

# Trap signals for graceful shutdown
trap 'echo ""; echo "📛 Received shutdown signal, stopping n8n..."; exit 0' SIGTERM SIGINT

# Start n8n with explicit host and port binding
# Add timestamps to all output
exec n8n start --host 0.0.0.0 --port $ACTUAL_PORT 2>&1 | while IFS= read -r line; do
    echo "[$(date +'%H:%M:%S')] $line"
    
    # Highlight important messages
    case "$line" in
        *"n8n ready on"*)
            echo "🎉 ========== N8N SUCCESSFULLY STARTED =========="
            ;;
        *"Error"*|*"ERROR"*|*"Failed"*|*"FAILED"*)
            echo "⚠️ ========== ERROR DETECTED =========="
            ;;
        *"listen EADDRINUSE"*)
            echo "❌ ========== PORT ALREADY IN USE =========="
            ;;
    esac
done