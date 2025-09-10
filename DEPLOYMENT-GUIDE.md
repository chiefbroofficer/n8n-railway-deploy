# 🚀 n8n Railway Deployment - Step-by-Step Guide

## ✅ Completed Steps

1. **Railway Project Created**: `n8n-production`
   - Project ID: `d165a966-103c-45a0-a35f-f2bb9c79f392`
   - URL: https://railway.com/project/d165a966-103c-45a0-a35f-f2bb9c79f392

2. **Deployment Files Ready**:
   - ✅ Dockerfile
   - ✅ railway.json
   - ✅ Environment configuration
   - ✅ Git repository initialized

3. **Credentials Generated** (SAVE THESE!):
   ```
   Admin Username: admin
   Admin Password: y6lSWQzENdlScPwK4jC4ltQ5
   Encryption Key: xEKm2kkRfSF6N80NNLYbDc6a2cxdyz1S
   ```

---

## 📋 Manual Steps Required

### Step 1: Open Railway Dashboard
Go to your project: https://railway.com/project/d165a966-103c-45a0-a35f-f2bb9c79f392

### Step 2: Add PostgreSQL Database
1. Click **"+ New"** button
2. Select **"Database"**
3. Choose **"Add PostgreSQL"**
4. Wait for PostgreSQL to deploy (takes ~30 seconds)

### Step 3: Add n8n Service
1. Click **"+ New"** button again
2. Select **"GitHub Repo"**
3. Choose **"Deploy from GitHub repo"**
4. Connect your GitHub account if not already connected
5. Create a new repo or select existing:
   - Repository name: `n8n-railway-deploy`
   - Make it private (recommended)

### Step 4: Push Code to GitHub
Run these commands in your terminal:

```bash
cd /Users/digitaldavinci/n8n-railway-deploy

# Create GitHub repository (if you have GitHub CLI)
gh repo create n8n-railway-deploy --private --source=. --push

# OR manually create on GitHub and push:
git remote add origin https://github.com/YOUR_USERNAME/n8n-railway-deploy.git
git branch -M main
git push -u origin main
```

### Step 5: Configure Environment Variables
In Railway Dashboard → n8n Service → Variables tab, add these:

```env
# Authentication (REQUIRED - Use the generated values above)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=y6lSWQzENdlScPwK4jC4ltQ5

# Encryption (REQUIRED - Use the generated value above)
N8N_ENCRYPTION_KEY=xEKm2kkRfSF6N80NNLYbDc6a2cxdyz1S

# Core Settings
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
NODE_ENV=production

# Database (These are auto-linked from PostgreSQL)
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{PGHOST}}
DB_POSTGRESDB_PORT=${{PGPORT}}
DB_POSTGRESDB_DATABASE=${{PGDATABASE}}
DB_POSTGRESDB_USER=${{PGUSER}}
DB_POSTGRESDB_PASSWORD=${{PGPASSWORD}}

# URLs (Auto-provided by Railway)
WEBHOOK_URL=${{RAILWAY_PUBLIC_DOMAIN}}
N8N_EDITOR_BASE_URL=${{RAILWAY_PUBLIC_DOMAIN}}

# API Settings
N8N_API_DISABLED=false
N8N_PUBLIC_API_DISABLED=false

# Timezone
GENERIC_TIMEZONE=America/New_York
TZ=America/New_York

# Telemetry
N8N_DIAGNOSTICS_ENABLED=false
N8N_PERSONALIZATION_ENABLED=false
```

### Step 6: Generate Domain
1. In Railway Dashboard → n8n Service → Settings
2. Under "Networking" section
3. Click **"Generate Domain"**
4. Copy your domain (e.g., `n8n-production.up.railway.app`)

### Step 7: Deploy
The deployment should start automatically when you push to GitHub.
If not, click **"Deploy"** in Railway dashboard.

### Step 8: Wait for Deployment
- First deployment takes 3-5 minutes
- Check logs: Railway Dashboard → n8n Service → Logs
- Wait for message: "n8n ready on http://0.0.0.0:5678"

### Step 9: Access n8n
1. Go to: `https://[your-domain].up.railway.app`
2. Login with:
   - Username: `admin`
   - Password: `y6lSWQzENdlScPwK4jC4ltQ5`

### Step 10: Enable API Access
1. In n8n: **Settings** → **API**
2. Toggle **"Public API"** to ON
3. Click **"Create an API Key"**
4. **COPY AND SAVE THE API KEY**

### Step 11: Update n8n MCP Configuration
Run this command with your values:

```bash
claude mcp configure n8n \
  --env N8N_API_URL=https://[your-domain].up.railway.app \
  --env N8N_API_KEY=[your-api-key-from-step-10]
```

---

## ✅ Verification Checklist

- [ ] PostgreSQL is running in Railway
- [ ] n8n service is deployed and running
- [ ] Domain is generated and accessible
- [ ] Can login to n8n with admin credentials
- [ ] API is enabled in n8n
- [ ] API key is generated
- [ ] n8n MCP is configured with Railway URL and API key
- [ ] Test in Claude Code: "List my n8n workflows"

---

## 🔧 Quick Commands

```bash
# Check deployment status
cd /Users/digitaldavinci/n8n-railway-deploy
railway status

# View logs
railway logs

# Open Railway dashboard
railway open

# Restart service
railway restart

# Check MCP connection
claude mcp list
```

---

## 🆘 Troubleshooting

### If n8n won't start:
1. Check logs: `railway logs`
2. Verify PostgreSQL is running
3. Check environment variables are set correctly
4. Ensure encryption key is exactly 32 characters

### If MCP can't connect:
1. Verify API is enabled in n8n
2. Check API key is correct
3. Ensure URL includes `https://`
4. Test with: `curl https://[your-domain].up.railway.app/healthz`

### If deployment fails:
1. Check Dockerfile syntax
2. Verify GitHub repository is connected
3. Check Railway build logs for errors
4. Try manual redeploy: `railway up`

---

## 📝 Notes

- First deployment takes longer (building Docker image)
- Subsequent deployments are faster (cached layers)
- Railway provides automatic SSL/HTTPS
- Database backups are automatic
- Costs approximately $10-20/month

---

## 🎉 Success Indicators

When everything is working, you should see:
1. ✅ Green "Running" status in Railway
2. ✅ n8n login page loads
3. ✅ Can create and save workflows
4. ✅ Claude Code can list workflows via MCP
5. ✅ Webhooks receive data

---

**Last Updated**: $(date)