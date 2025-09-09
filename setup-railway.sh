#!/bin/bash

# n8n Railway Deployment Setup Script
# This script automates the deployment of n8n to Railway

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           n8n Railway Deployment Setup Script              ║"
echo "║                  Automated Installation                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check for Railway CLI
check_railway_cli() {
    print_info "Checking for Railway CLI..."
    if ! command -v railway &> /dev/null; then
        print_error "Railway CLI not found!"
        print_info "Installing Railway CLI..."
        
        # Detect OS and install accordingly
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install railway
            else
                curl -fsSL https://railway.app/install.sh | sh
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            curl -fsSL https://railway.app/install.sh | sh
        else
            print_error "Unsupported operating system"
            exit 1
        fi
    else
        print_message "Railway CLI found"
    fi
}

# Check for Git
check_git() {
    print_info "Checking for Git..."
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    else
        print_message "Git found"
    fi
}

# Initialize Git repository
init_git_repo() {
    print_info "Initializing Git repository..."
    
    if [ ! -d .git ]; then
        git init
        print_message "Git repository initialized"
    else
        print_warning "Git repository already exists"
    fi
    
    # Create .gitignore if it doesn't exist
    if [ ! -f .gitignore ]; then
        cat > .gitignore << 'EOF'
# Environment variables
.env
.env.local
.env.production

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# n8n
.n8n/
*.node

# Docker
docker-compose.override.yml

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Temp files
tmp/
temp/
EOF
        print_message ".gitignore created"
    fi
    
    # Add files to git
    git add .
    git commit -m "Initial n8n Railway deployment setup" 2>/dev/null || print_warning "No changes to commit"
}

# Generate secure passwords
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

# Create environment file for Railway
create_env_file() {
    print_info "Creating environment configuration..."
    
    # Generate secure passwords
    ADMIN_PASSWORD=$(generate_password)
    ENCRYPTION_KEY=$(generate_password)
    
    cat > .env.railway << EOF
# Auto-generated Railway environment variables
# Copy these to Railway dashboard

N8N_BASIC_AUTH_PASSWORD=${ADMIN_PASSWORD}
N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}

# Save these credentials securely:
# Admin Username: admin
# Admin Password: ${ADMIN_PASSWORD}
# Encryption Key: ${ENCRYPTION_KEY}
EOF
    
    print_message "Environment configuration created"
    print_warning "IMPORTANT: Save these credentials securely!"
    echo -e "${YELLOW}Admin Username:${NC} admin"
    echo -e "${YELLOW}Admin Password:${NC} ${ADMIN_PASSWORD}"
    echo -e "${YELLOW}Encryption Key:${NC} ${ENCRYPTION_KEY}"
}

# Login to Railway
railway_login() {
    print_info "Logging into Railway..."
    
    if railway whoami &> /dev/null; then
        print_message "Already logged into Railway"
    else
        print_warning "Please login to Railway"
        railway login
    fi
}

# Create Railway project
create_railway_project() {
    print_info "Creating Railway project..."
    
    # Check if already linked to a project
    if railway status &> /dev/null; then
        print_warning "Already linked to a Railway project"
        read -p "Do you want to create a new project? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    # Create new project
    print_info "Creating new Railway project..."
    railway init
    print_message "Railway project created"
}

# Add PostgreSQL to Railway
add_postgresql() {
    print_info "Adding PostgreSQL database..."
    
    echo -e "${YELLOW}Please do the following in your Railway dashboard:${NC}"
    echo "1. Go to your Railway project dashboard"
    echo "2. Click 'New' → 'Database' → 'Add PostgreSQL'"
    echo "3. Wait for PostgreSQL to deploy"
    echo ""
    read -p "Press Enter when PostgreSQL is deployed..."
    
    print_message "PostgreSQL added to project"
}

# Deploy to Railway
deploy_to_railway() {
    print_info "Deploying n8n to Railway..."
    
    # Ensure we're on main branch
    git checkout -b main 2>/dev/null || git checkout main
    
    # Deploy
    railway up --detach
    
    print_message "Deployment initiated"
    print_info "Deployment will take 2-5 minutes..."
}

# Get deployment URL
get_deployment_url() {
    print_info "Getting deployment URL..."
    
    # Wait a moment for deployment to register
    sleep 5
    
    # Get the URL
    URL=$(railway domain 2>/dev/null || echo "")
    
    if [ -z "$URL" ]; then
        print_warning "Could not get URL automatically"
        echo -e "${YELLOW}Please get your URL from the Railway dashboard${NC}"
    else
        print_message "Your n8n instance URL: https://${URL}"
        echo "https://${URL}" > deployment-url.txt
    fi
}

# Configure environment variables in Railway
configure_railway_env() {
    print_info "Configuring environment variables..."
    
    echo -e "${YELLOW}Please configure the following environment variables in Railway:${NC}"
    echo ""
    echo "1. Go to your Railway project dashboard"
    echo "2. Click on your n8n service"
    echo "3. Go to 'Variables' tab"
    echo "4. Add the following variables:"
    echo ""
    cat .env.railway
    echo ""
    echo "5. Also ensure these Railway-provided variables are connected:"
    echo "   - DATABASE_URL (from PostgreSQL)"
    echo "   - RAILWAY_STATIC_URL"
    echo ""
    read -p "Press Enter when environment variables are configured..."
    
    print_message "Environment variables configured"
}

# Update MCP configuration
update_mcp_config() {
    print_info "Updating n8n MCP configuration..."
    
    if [ -f deployment-url.txt ]; then
        URL=$(cat deployment-url.txt)
    else
        read -p "Enter your n8n Railway URL (e.g., https://your-app.up.railway.app): " URL
    fi
    
    read -p "Enter your n8n API key (from n8n Settings → API): " API_KEY
    
    # Update MCP configuration
    claude mcp configure n8n \
        --env N8N_API_URL="${URL}" \
        --env N8N_API_KEY="${API_KEY}" \
        2>/dev/null || {
            print_warning "Could not update MCP automatically"
            echo "Please run manually:"
            echo "claude mcp configure n8n --env N8N_API_URL=${URL} --env N8N_API_KEY=${API_KEY}"
        }
    
    print_message "MCP configuration updated"
}

# Test the connection
test_connection() {
    print_info "Testing n8n connection..."
    
    if [ -f deployment-url.txt ]; then
        URL=$(cat deployment-url.txt)
        
        # Test basic connectivity
        if curl -s "${URL}/healthz" > /dev/null; then
            print_message "n8n is running and healthy!"
        else
            print_warning "n8n might still be starting up. Please wait a few minutes."
        fi
    fi
}

# Main execution flow
main() {
    echo -e "${BLUE}Starting n8n Railway deployment setup...${NC}"
    echo ""
    
    # Step 1: Check prerequisites
    check_railway_cli
    check_git
    
    # Step 2: Initialize repository
    init_git_repo
    
    # Step 3: Create environment configuration
    create_env_file
    
    # Step 4: Railway setup
    railway_login
    create_railway_project
    
    # Step 5: Add PostgreSQL
    add_postgresql
    
    # Step 6: Configure environment variables
    configure_railway_env
    
    # Step 7: Deploy
    deploy_to_railway
    
    # Step 8: Get URL
    get_deployment_url
    
    # Step 9: Wait for deployment
    echo -e "${YELLOW}Waiting for deployment to complete (this takes 2-5 minutes)...${NC}"
    sleep 120
    
    # Step 10: Test connection
    test_connection
    
    # Step 11: Update MCP
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Deployment complete!${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Go to your n8n instance and complete setup"
    echo "2. Enable API access in n8n Settings → API"
    echo "3. Generate an API key"
    echo "4. Update MCP configuration with:"
    echo "   claude mcp configure n8n --env N8N_API_URL=<your-url> --env N8N_API_KEY=<your-key>"
    echo ""
    
    # Save summary
    cat > deployment-summary.txt << EOF
n8n Railway Deployment Summary
==============================
Date: $(date)
Project Directory: $(pwd)

Credentials (SAVE THESE SECURELY):
----------------------------------
$(cat .env.railway)

Deployment URL:
--------------
$(cat deployment-url.txt 2>/dev/null || echo "Check Railway dashboard")

Next Steps:
----------
1. Access your n8n instance
2. Enable API: Settings → API
3. Generate API key
4. Update MCP configuration

MCP Update Command:
------------------
claude mcp configure n8n --env N8N_API_URL=<url> --env N8N_API_KEY=<key>
EOF
    
    print_message "Deployment summary saved to deployment-summary.txt"
}

# Run main function
main