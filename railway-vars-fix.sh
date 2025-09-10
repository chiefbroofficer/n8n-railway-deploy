#!/bin/bash
# Fix Railway environment variables for n8n PORT binding

echo "🚂 Setting up Railway variables for proper PORT binding..."
echo ""
echo "This script will set N8N_PORT and N8N_HOST to use Railway's dynamic PORT"
echo ""

# Ensure we're in the right directory
cd /Users/digitaldavinci/n8n-railway-deploy

echo "📝 Adding N8N_PORT and N8N_HOST variables..."
echo ""
echo "Run these commands after 'railway login' and 'railway link':"
echo ""
echo "railway variables --set \"N8N_PORT=\${{PORT}}\""
echo "railway variables --set \"N8N_HOST=0.0.0.0\""
echo ""
echo "These tell n8n to use Railway's dynamic PORT and bind to all interfaces."