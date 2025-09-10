# 🚂 Railway CLI Setup for n8n

## ✅ Railway CLI Installed!
The Railway CLI has been successfully installed via npm.

## 🔐 Login Required
Railway CLI requires interactive browser authentication. Run:
```bash
railway login
```

This will open your browser to authenticate with Railway.

## 🚀 Quick Setup (After Login)

### Option 1: Run the Setup Script
```bash
cd /Users/digitaldavinci/n8n-railway-deploy
./setup-railway-vars.sh
```

This script will:
1. Link to your Railway project
2. Set all required environment variables
3. Trigger automatic redeployment

### Option 2: Manual Commands
If the script doesn't work, run these commands manually:

```bash
cd /Users/digitaldavinci/n8n-railway-deploy

# Link to project (select "chiefbroofficer's Projects" → "n8n-railway-deploy")
railway link

# Add all variables
railway variables --set "DB_TYPE=postgresdb"
railway variables --set "DB_POSTGRESDB_DATABASE=\${{Postgres.PGDATABASE}}"
railway variables --set "DB_POSTGRESDB_HOST=\${{Postgres.PGHOST}}"
railway variables --set "DB_POSTGRESDB_PORT=\${{Postgres.PGPORT}}"
railway variables --set "DB_POSTGRESDB_USER=\${{Postgres.PGUSER}}"
railway variables --set "DB_POSTGRESDB_PASSWORD=\${{Postgres.PGPASSWORD}}"
railway variables --set "N8N_PORT=\${{PORT}}"
railway variables --set "N8N_HOST=0.0.0.0"
railway variables --set "N8N_BASIC_AUTH_ACTIVE=true"
railway variables --set "N8N_BASIC_AUTH_USER=admin"
railway variables --set "N8N_BASIC_AUTH_PASSWORD=y6lSWQzENdlScPwK4jC4ltQ5"
railway variables --set "N8N_ENCRYPTION_KEY=xEKm2kkRfSF6N80NNLYbDc6a2cxdyz1S"
railway variables --set "N8N_PROTOCOL=https"
railway variables --set "NODE_ENV=production"
railway variables --set "EXECUTIONS_PROCESS=main"
```

## 🌐 Generate Public Domain
After variables are set and deployment succeeds:
```bash
railway domain
```

This will generate a public URL like: `n8n-railway-deploy-production-xxxx.up.railway.app`

## 🔍 Check Deployment Status
```bash
railway status
railway logs
```

## ✅ Verify Success
1. Wait 2-3 minutes for deployment
2. Check logs for: "n8n ready on 0.0.0.0"
3. Visit your Railway URL
4. Login with:
   - Username: `admin`
   - Password: `y6lSWQzENdlScPwK4jC4ltQ5`

## 🚨 Troubleshooting
If deployment still fails after adding variables:
```bash
# Check logs
railway logs

# Restart service
railway restart

# Check variable status
railway variables
```

## 📝 Important Notes
- PostgreSQL is already provisioned (added 14 hours ago)
- Variables use Railway's template syntax: `${{Postgres.VARIABLE}}`
- Service auto-redeploys when variables change
- Domain generation is one-time only