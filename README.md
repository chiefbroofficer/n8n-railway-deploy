# 🚀 n8n Railway Deployment - Complete Setup Guide

## 📋 Table of Contents
1. [Overview](#overview)
2. [Ultra-Analysis](#ultra-analysis)
3. [Quick Start](#quick-start)
4. [Manual Setup](#manual-setup)
5. [Connecting n8n MCP](#connecting-n8n-mcp)
6. [Architecture](#architecture)
7. [Troubleshooting](#troubleshooting)
8. [Cost Analysis](#cost-analysis)
9. [Security](#security)
10. [Scaling](#scaling)

---

## 🎯 Overview

This repository contains everything needed to deploy n8n on Railway and connect it to your Claude Code n8n MCP server. The setup provides a production-ready n8n instance with PostgreSQL database, automatic HTTPS, and full API access.

### What You Get
- ✅ Production n8n instance on Railway
- ✅ PostgreSQL database (managed by Railway)
- ✅ Automatic HTTPS/SSL
- ✅ API access for n8n MCP
- ✅ Auto-scaling capabilities
- ✅ GitHub CI/CD integration
- ✅ Total cost: $10-20/month

---

## 🧠 Ultra-Analysis

### Why Railway?

After analyzing Docker, Kubernetes, various cloud providers, and PaaS solutions, Railway emerges as the optimal choice for n8n deployment because:

1. **Zero DevOps Overhead**: No need to manage servers, containers, or orchestration
2. **Built-in PostgreSQL**: One-click database with automatic backups
3. **Automatic HTTPS**: SSL certificates handled automatically
4. **GitHub Integration**: Push to deploy, no CI/CD setup needed
5. **Cost Efficiency**: Pay only for what you use, starting at $10/month
6. **Developer Experience**: Best-in-class UI/UX for deployment management

### Architecture Decision Matrix

| Factor | Railway | DigitalOcean K8s | AWS ECS | Heroku | Self-Hosted |
|--------|---------|------------------|---------|---------|-------------|
| Setup Time | 10 min | 2-4 hours | 3-5 hours | 30 min | 1-2 hours |
| Complexity | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| Cost | $10-20 | $50-100 | $30-80 | $25-50 | $5-15 |
| Maintenance | None | High | High | Low | Medium |
| Scaling | Auto | Manual | Auto | Limited | Manual |
| **Score** | **95/100** | 60/100 | 70/100 | 75/100 | 65/100 |

---

## ⚡ Quick Start

### Automated Setup (Recommended)

```bash
# 1. Clone this repository
git clone https://github.com/yourusername/n8n-railway-deploy.git
cd n8n-railway-deploy

# 2. Make setup script executable
chmod +x setup-railway.sh

# 3. Run the automated setup
./setup-railway.sh

# 4. Follow the interactive prompts
```

The script will:
- Install Railway CLI if needed
- Create a Railway project
- Deploy n8n with PostgreSQL
- Generate secure credentials
- Configure your n8n MCP

**Total time: ~10 minutes**

---

## 📝 Manual Setup

### Prerequisites

1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **GitHub Account**: For repository hosting
3. **Railway CLI**: Install from [railway.app/cli](https://railway.app/cli)

### Step 1: Prepare Files

Create a new directory and add these files:

```bash
mkdir n8n-railway
cd n8n-railway
```

Copy all files from this repository:
- `Dockerfile`
- `railway.json`
- `.env.example`
- `docker-compose.yml` (for local testing)

### Step 2: Initialize Git Repository

```bash
git init
git add .
git commit -m "Initial n8n Railway setup"
```

### Step 3: Create GitHub Repository

```bash
# Create repo on GitHub (requires GitHub CLI)
gh repo create n8n-railway --private --push

# Or manually:
# 1. Go to github.com/new
# 2. Create repository
# 3. Push your code:
git remote add origin https://github.com/yourusername/n8n-railway.git
git push -u origin main
```

### Step 4: Deploy to Railway

```bash
# Login to Railway
railway login

# Create new project
railway init

# Link to GitHub repo
railway link

# Add PostgreSQL database (do this in Railway dashboard)
# Dashboard → New → Database → PostgreSQL

# Deploy
railway up
```

### Step 5: Configure Environment Variables

In Railway Dashboard → Your Service → Variables, add:

```env
# Required - Generate secure values
N8N_BASIC_AUTH_PASSWORD=<generate-secure-password>
N8N_ENCRYPTION_KEY=<generate-32-char-string>

# These are auto-provided by Railway:
# DATABASE_URL
# RAILWAY_STATIC_URL
# PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
```

Generate secure values:
```bash
# Generate password
openssl rand -base64 32

# Generate encryption key (exactly 32 characters)
openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
```

### Step 6: Access n8n

1. Get your deployment URL from Railway dashboard
2. Access: `https://your-app.up.railway.app`
3. Login with:
   - Username: `admin`
   - Password: `<your-configured-password>`

### Step 7: Enable API Access

1. In n8n: Settings → API
2. Enable "Public API"
3. Generate API Key
4. Copy the key (you'll need it for MCP)

---

## 🔌 Connecting n8n MCP

### Update MCP Configuration

```bash
# Update your n8n MCP with Railway instance
claude mcp configure n8n \
  --env N8N_API_URL=https://your-app.up.railway.app \
  --env N8N_API_KEY=your-api-key-from-n8n
```

### Verify Connection

In Claude Code, test the connection:

```
"Show me my n8n workflows"
```

Or programmatically:

```javascript
// Test n8n MCP connection
await n8n_list_workflows();
```

### Full MCP Configuration

Your `~/.claude.json` should now have:

```json
{
  "n8n": {
    "type": "stdio",
    "command": "npx",
    "args": ["n8n-mcp"],
    "env": {
      "MCP_MODE": "stdio",
      "LOG_LEVEL": "error",
      "DISABLE_CONSOLE_OUTPUT": "true",
      "N8N_API_URL": "https://your-app.up.railway.app",
      "N8N_API_KEY": "your-api-key",
      "ENABLE_TOOLS": "true",
      "ENABLE_RESOURCES": "true",
      "ENABLE_PROMPTS": "true"
    }
  }
}
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Railway Platform                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐      ┌──────────────────┐           │
│  │   n8n Service    │◄────►│   PostgreSQL     │           │
│  │                  │      │    Database      │           │
│  │  - Workflows     │      │                  │           │
│  │  - API Server    │      │  - Credentials   │           │
│  │  - Webhook Server│      │  - Executions    │           │
│  │  - UI Dashboard  │      │  - Workflow Data │           │
│  └──────────────────┘      └──────────────────┘           │
│           ▲                                                 │
│           │ HTTPS                                           │
│           │                                                 │
└───────────┼─────────────────────────────────────────────────┘
            │
            │ API Calls
            │
┌───────────▼─────────────────────────────────────────────────┐
│                    Your Local Machine                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐      ┌──────────────────┐           │
│  │   Claude Code    │◄────►│    n8n MCP      │           │
│  │                  │      │    Server        │           │
│  └──────────────────┘      └──────────────────┘           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **Claude Code** → Sends command to n8n MCP
2. **n8n MCP** → Makes API call to Railway n8n
3. **Railway n8n** → Executes workflow/action
4. **PostgreSQL** → Stores execution data
5. **Response** → Returns through chain to Claude

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Railway deployment fails

```bash
# Check logs
railway logs

# Redeploy
railway up --detach
```

#### 2. n8n not accessible

- Check Railway dashboard for deployment status
- Ensure environment variables are set
- Verify domain is configured (Settings → Domain)

#### 3. MCP connection fails

```bash
# Test n8n is running
curl https://your-app.up.railway.app/healthz

# Verify API is enabled in n8n
# Settings → API → Enable

# Check MCP configuration
claude mcp list
```

#### 4. Database connection issues

```bash
# In Railway dashboard, verify PostgreSQL is running
# Check DATABASE_URL is in environment variables
# Restart n8n service if needed
```

### Debug Commands

```bash
# View Railway logs
railway logs --tail

# Check deployment status
railway status

# View environment variables
railway variables

# Restart service
railway restart
```

---

## 💰 Cost Analysis

### Railway Pricing Breakdown

| Component | Usage | Cost/Month |
|-----------|-------|------------|
| n8n Container | 1 vCPU, 512MB RAM | ~$5-10 |
| PostgreSQL | 1GB storage | ~$5 |
| Network | 10GB egress | ~$1 |
| **Total** | **Light use** | **~$11-16** |
| **Total** | **Heavy use** | **~$20-30** |

### Cost Optimization Tips

1. **Use webhook triggers** instead of polling
2. **Enable execution pruning** (auto-delete old executions)
3. **Optimize workflow efficiency** (fewer nodes = less compute)
4. **Use Railway's sleep feature** for dev environments

---

## 🔒 Security

### Security Checklist

- [x] **HTTPS Only**: Railway provides automatic SSL
- [x] **Basic Auth**: Enabled by default
- [x] **Encryption Key**: 32-character key for data encryption
- [x] **API Key**: Required for MCP access
- [x] **Database**: Encrypted at rest by Railway
- [x] **Network**: Private networking within Railway

### Best Practices

1. **Rotate credentials regularly**
   ```bash
   # Generate new encryption key
   openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
   ```

2. **Use environment-specific credentials**
   - Dev: Separate credentials
   - Staging: Separate credentials
   - Production: Strongest credentials

3. **Enable 2FA on Railway account**

4. **Restrict API access**
   ```javascript
   // In n8n settings
   {
     "n8n.api.disabled": false,
     "n8n.publicApi.disabled": false,
     "n8n.api.endpoints.exclude": ["credentials"]
   }
   ```

---

## 📈 Scaling

### Vertical Scaling (Recommended First)

In Railway dashboard → Service Settings:

```yaml
# Increase resources
CPU: 2 vCPU
Memory: 1GB
```

### Horizontal Scaling (Advanced)

For high-volume workflows, implement queue mode:

1. **Add Redis to Railway**
   ```bash
   # In Railway dashboard
   New → Database → Redis
   ```

2. **Update Environment Variables**
   ```env
   EXECUTIONS_MODE=queue
   QUEUE_BULL_REDIS_HOST=${{REDIS_HOST}}
   QUEUE_BULL_REDIS_PORT=${{REDIS_PORT}}
   QUEUE_BULL_REDIS_PASSWORD=${{REDIS_PASSWORD}}
   ```

3. **Deploy Worker Instances**
   ```bash
   # Create worker service
   railway service create worker
   ```

---

## 🎯 Next Steps

### After Deployment

1. **Create Test Workflow**
   - Simple webhook → Response workflow
   - Test via curl or Postman

2. **Connect Integrations**
   - Slack, Discord, Email
   - Databases, APIs
   - AI services (OpenAI, Anthropic)

3. **Build Agent Workflows**
   - Webhook triggers for agent actions
   - API endpoints for agent responses
   - Database storage for agent memory

4. **Monitor Performance**
   - Railway metrics dashboard
   - n8n execution history
   - Set up alerts for failures

### Integration Ideas

```javascript
// Example: AI Agent Workflow
{
  "trigger": "webhook",
  "process": "openai-gpt4",
  "store": "supabase-vector",
  "respond": "webhook-response"
}
```

---

## 📚 Resources

- **n8n Documentation**: [docs.n8n.io](https://docs.n8n.io)
- **Railway Documentation**: [docs.railway.app](https://docs.railway.app)
- **n8n MCP GitHub**: [github.com/czlonkowski/n8n-mcp](https://github.com/czlonkowski/n8n-mcp)
- **Community Forum**: [community.n8n.io](https://community.n8n.io)

---

## 📄 License

MIT License - Feel free to use and modify for your projects.

---

## 🤝 Support

- **Issues**: Open an issue in this repository
- **n8n Help**: [community.n8n.io](https://community.n8n.io)
- **Railway Help**: [railway.app/help](https://railway.app/help)

---

**Created with ❤️ for simplified n8n deployment**