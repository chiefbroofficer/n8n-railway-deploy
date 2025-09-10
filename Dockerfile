# Minimal n8n for Railway
FROM n8nio/n8n:latest

# Railway requires listening on 0.0.0.0
ENV N8N_HOST=0.0.0.0

# Use shell form for PORT variable expansion
CMD n8n start --port ${PORT:-5678}