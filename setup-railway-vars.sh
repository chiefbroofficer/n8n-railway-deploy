#!/bin/bash

# Railway n8n Environment Variables Setup Script
# Run this after logging in with: railway login

echo "🚀 Setting up n8n Railway environment variables..."

# First, link to your project
echo "📎 Linking to Railway project..."
railway link

# Set all required environment variables
echo "⚙️ Adding database configuration..."
railway variables --set "DB_TYPE=postgresdb"
railway variables --set "DB_POSTGRESDB_DATABASE=\${{Postgres.PGDATABASE}}"
railway variables --set "DB_POSTGRESDB_HOST=\${{Postgres.PGHOST}}"
railway variables --set "DB_POSTGRESDB_PORT=\${{Postgres.PGPORT}}"
railway variables --set "DB_POSTGRESDB_USER=\${{Postgres.PGUSER}}"
railway variables --set "DB_POSTGRESDB_PASSWORD=\${{Postgres.PGPASSWORD}}"

echo "🔧 Adding port configuration..."
railway variables --set "N8N_PORT=\${{PORT}}"
railway variables --set "N8N_HOST=0.0.0.0"

echo "🔐 Adding authentication..."
railway variables --set "N8N_BASIC_AUTH_ACTIVE=true"
railway variables --set "N8N_BASIC_AUTH_USER=admin"
railway variables --set "N8N_BASIC_AUTH_PASSWORD=y6lSWQzENdlScPwK4jC4ltQ5"

echo "🔑 Adding encryption key..."
railway variables --set "N8N_ENCRYPTION_KEY=xEKm2kkRfSF6N80NNLYbDc6a2cxdyz1S"

echo "🌐 Adding protocol settings..."
railway variables --set "N8N_PROTOCOL=https"
railway variables --set "NODE_ENV=production"
railway variables --set "EXECUTIONS_PROCESS=main"

echo "✅ All variables set! Your service will auto-redeploy."
echo ""
echo "📌 Next steps:"
echo "1. Wait for deployment to complete (~2-3 minutes)"
echo "2. Run: railway domain"
echo "3. Access n8n at the generated URL"
echo "4. Login with username: admin, password: y6lSWQzENdlScPwK4jC4ltQ5"