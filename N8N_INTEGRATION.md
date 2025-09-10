# 🔗 N8N Integration Guide

## ✅ Deployment Status
Your n8n instance is successfully deployed and running at:
- **URL**: https://n8n-railway-deploy-production-1b25.up.railway.app/
- **Status**: ✅ ACTIVE

## 🔑 Credentials

### Basic Authentication (Web UI)
- **Username**: admin
- **Password**: y6lSWQzENdlScPwK4jC4ltQ5

### API Access
- **API Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0NzkyZWM4Yi02Mzc0LTQwMjQtYWEzMy1iODVmZTQ4ZWEzZGMiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU3NTM3OTg2fQ.zd4Rg62BXiNluvTquJsLlzqD0S4FkckUn5xUCFHzPY8`
- **Base URL**: `https://n8n-railway-deploy-production-1b25.up.railway.app/api/v1`

### Activation Key
- **License Key**: `2690f8b5-b0fa-4dac-b4b5-c2e173106258`
- **Status**: ✅ Added to Railway environment

## 📡 API Testing

### Test API Connection
```bash
# Test API with your key
curl -X GET https://n8n-railway-deploy-production-1b25.up.railway.app/api/v1/workflows \
  -H "X-N8N-API-KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0NzkyZWM4Yi02Mzc0LTQwMjQtYWEzMy1iODVmZTQ4ZWEzZGMiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU3NTM3OTg2fQ.zd4Rg62BXiNluvTquJsLlzqD0S4FkckUn5xUCFHzPY8"
```

## 🤖 n8n MCP Server Setup (Optional)

If you want to control n8n from Claude, you can set up the n8n MCP server:

### 1. Install n8n MCP Server
```bash
npm install -g @modelcontextprotocol/server-n8n
```

### 2. Configure Claude Desktop
Add to your Claude Desktop config (usually at `~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "n8n": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-n8n",
        "--url", "https://n8n-railway-deploy-production-1b25.up.railway.app",
        "--api-key", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0NzkyZWM4Yi02Mzc0LTQwMjQtYWEzMy1iODVmZTQ4ZWEzZGMiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU3NTM3OTg2fQ.zd4Rg62BXiNluvTquJsLlzqD0S4FkckUn5xUCFHzPY8"
      ]
    }
  }
}
```

## 🔄 Next Steps

1. **Create Your First Workflow**:
   - Click "Start from scratch" or "Try a pre-built agent" in the n8n UI
   - Build your automation workflow
   - Save and activate it

2. **Test Webhooks**:
   - Create a webhook node
   - Use the production URL: `https://n8n-railway-deploy-production-1b25.up.railway.app/webhook/[your-webhook-path]`

3. **Connect Integrations**:
   - Add credentials for services you want to automate
   - Popular: Slack, Discord, Google Sheets, GitHub, etc.

## 🔧 Troubleshooting

### If API calls fail:
1. Verify the API key is correct
2. Check if n8n API is enabled in Settings → API
3. Ensure the instance is running

### If webhooks don't work:
1. Check that WEBHOOK_URL is set correctly in Railway
2. Verify the webhook path in your workflow
3. Test with a tool like Postman or curl

## 📝 Environment Variables (Already Set in Railway)

```
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=y6lSWQzENdlScPwK4jC4ltQ5
N8N_HOST=0.0.0.0
N8N_PORT=${{PORT}}
N8N_PROTOCOL=https
N8N_LICENSE_ACTIVATION_KEY=2690f8b5-b0fa-4dac-b4b5-c2e173106258
WEBHOOK_URL=https://n8n-railway-deploy-production-1b25.up.railway.app/
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres.railway.internal
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=railway
DB_POSTGRESDB_USER=postgres
DB_POSTGRESDB_PASSWORD=VqPWNFSYVGQNlwPGhZSdKvFzvHWxMgBd
```

---
*Last Updated: 2025-09-10*
*n8n is fully operational and ready for workflow automation!*