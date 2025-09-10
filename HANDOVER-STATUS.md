# 🚂 N8N Railway Deployment - Handover Document

## Current Status: 🔴 BLOCKED - 502 Error
Last Updated: 2025-09-10

## Quick Access
- **Live URL**: https://n8n-railway-deploy-production-1b25.up.railway.app/
- **GitHub**: https://github.com/chiefbroofficer/n8n-railway-deploy
- **Railway Dashboard**: https://railway.app/project/[PROJECT_ID]
- **Status**: 502 "Application failed to respond"

## Problem Summary
n8n is not binding to the correct port that Railway expects. Railway dynamically assigns a PORT at runtime and expects apps to bind to `0.0.0.0:$PORT`. n8n needs to be told explicitly to use this PORT via environment variables.

## ✅ What's Working
1. **PostgreSQL Database**: Provisioned and connected
2. **GitHub Integration**: Auto-deploys on push to master
3. **Domain**: Generated at n8n-railway-deploy-production-1b25.up.railway.app
4. **Environment Variables**: Most are set correctly
5. **Authentication**: Basic auth configured (admin/y6lSWQzENdlScPwK4jC4ltQ5)

## ❌ What's Not Working
1. **PORT Binding**: n8n not binding to Railway's dynamic PORT
2. **502 Error**: Railway can't reach n8n application
3. **Missing Variables**: N8N_PORT and N8N_HOST not properly set

## 🔧 Technical Details

### Current Dockerfile (Simplified)
```dockerfile
FROM n8nio/n8n:latest

# Railway will set PORT at runtime
# n8n will use N8N_PORT and N8N_HOST from environment
ENV NODE_ENV=production
ENV N8N_PROTOCOL=https
ENV EXECUTIONS_PROCESS=main

# Start n8n directly
CMD ["n8n"]
```

### Required Railway Variables
```bash
N8N_PORT=${{PORT}}  # ⚠️ CRITICAL - Must be set
N8N_HOST=0.0.0.0   # ⚠️ CRITICAL - Must be set
```

## 🎯 To Fix The Issue

### Step 1: Railway CLI Login
```bash
railway login
# This opens browser for authentication
```

### Step 2: Link to Project
```bash
cd /Users/digitaldavinci/n8n-railway-deploy
railway link
# Select: chiefbroofficer's Projects → n8n-railway-deploy
```

### Step 3: Add Missing Variables
```bash
railway variables --set "N8N_PORT=\${{PORT}}"
railway variables --set "N8N_HOST=0.0.0.0"
```

### Step 4: Verify & Restart
```bash
railway variables  # Check all variables
railway restart    # Force redeploy
railway logs       # Watch for "n8n ready on 0.0.0.0"
```

## 📁 Project Structure
```
/Users/digitaldavinci/n8n-railway-deploy/
├── Dockerfile                 # Main container config
├── entrypoint.sh             # Previous attempt (not used)
├── startup.sh                # Previous attempt (not used)
├── start.sh                  # Previous attempt (not used)
├── setup-railway-vars.sh     # Variable setup script
├── railway-vars-fix.sh       # Latest fix instructions
├── RAILWAY-CLI-SETUP.md      # CLI installation guide
└── HANDOVER-STATUS.md        # This document
```

## 🔍 Debug Checklist
- [ ] Railway CLI logged in
- [ ] Project linked correctly
- [ ] N8N_PORT set to ${{PORT}}
- [ ] N8N_HOST set to 0.0.0.0
- [ ] Deployment restarted
- [ ] Logs show "n8n ready on 0.0.0.0:[PORT]"
- [ ] 502 error resolved
- [ ] Can access n8n UI

## 📝 Previous Attempts Log
1. **Shell Expansion**: Used `/bin/sh -c` in CMD - Failed
2. **Startup Script**: Created startup.sh with debugging - Failed
3. **Entrypoint Script**: Used ENTRYPOINT with script - Failed
4. **Direct ENV**: Set N8N_PORT/HOST in entrypoint - Failed
5. **Simplified**: Minimal Dockerfile, rely on Railway vars - Pending

## 🚀 Once Fixed
When the 502 error is resolved, you should:
1. Access https://n8n-railway-deploy-production-1b25.up.railway.app/
2. Login with: admin / y6lSWQzENdlScPwK4jC4ltQ5
3. Set up workflows
4. Test webhook endpoints

## 💡 Alternative Solutions If Still Failing
1. **Use railway.json**: Create config file with build/start commands
2. **nixpacks.toml**: Override build process
3. **Custom Start Command**: Set in Railway dashboard
4. **Fork n8n-heroku**: Adapt their Dockerfile approach

## 🔗 MCP Tools Available
- `mcp__railway__*` - Railway CLI operations (requires login)
- `mcp__broGitHub__*` - GitHub repository management
- `mcp__context7__*` - Documentation lookup
- `mcp__supabase__*` - Database operations

## 📞 Support Resources
- Railway Discord: https://discord.gg/railway
- n8n Forum: https://community.n8n.io/
- Railway Docs: https://docs.railway.app/

## ⚠️ Critical Note
The main issue is that n8n needs to know about Railway's dynamic PORT. Without N8N_PORT=${{PORT}} and N8N_HOST=0.0.0.0 set in Railway's environment variables, n8n will default to localhost:5678 which Railway cannot reach, causing the 502 error.

---
*This deployment has been attempted multiple times with various approaches. The solution requires setting N8N_PORT and N8N_HOST in Railway's environment variables panel or via CLI.*