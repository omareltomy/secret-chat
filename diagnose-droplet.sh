#!/bin/bash

# Comprehensive Droplet Diagnostic Script
echo "🔍 Diagnosing Secret Chat deployment issues..."
echo "================================================="

# Basic info
echo "📍 Current location: $(pwd)"
echo "👤 Current user: $(whoami)"
echo "🕐 Current time: $(date)"
echo ""

# Check if we're in the right place
echo "📁 Directory structure check:"
if [ -d "/var/www/secret-chat" ]; then
    echo "✅ /var/www/secret-chat exists"
    cd /var/www/secret-chat
    echo "📂 Contents of /var/www/secret-chat:"
    ls -la
    echo ""
else
    echo "❌ /var/www/secret-chat not found!"
    echo "🔍 Searching for secret-chat directories..."
    find / -name "*secret-chat*" -type d 2>/dev/null
    exit 1
fi

# Check essential files
echo "📋 Essential files check:"
files=("package.json" "server.js" ".env" "public/index.html" "public/script.js" "public/styles.css")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists ($(stat -c%s "$file") bytes)"
    else
        echo "❌ $file MISSING!"
    fi
done
echo ""

# Check public directory specifically
echo "📂 Public directory contents:"
if [ -d "public" ]; then
    ls -la public/
    echo ""
    echo "📄 File sizes in public:"
    du -h public/*
else
    echo "❌ Public directory missing!"
fi
echo ""

# Check Node.js and npm
echo "🔧 System tools:"
echo "Node.js: $(node --version 2>/dev/null || echo 'NOT INSTALLED')"
echo "NPM: $(npm --version 2>/dev/null || echo 'NOT INSTALLED')"
echo "PM2: $(pm2 --version 2>/dev/null || echo 'NOT INSTALLED')"
echo ""

# Check PM2 processes
echo "📊 PM2 processes:"
pm2 list 2>/dev/null || echo "PM2 not running or no processes"
echo ""

# Check what's running on port 3000
echo "🌐 Port 3000 status:"
netstat -tulpn 2>/dev/null | grep :3000 || echo "Nothing on port 3000"
echo ""

# Check recent PM2 logs
echo "📝 Recent PM2 logs (last 20 lines):"
pm2 logs secret-chat --lines 20 2>/dev/null || echo "No PM2 logs for secret-chat"
echo ""

# Test file serving manually
echo "🧪 Testing file access:"
if [ -f "public/index.html" ]; then
    echo "📄 index.html first 3 lines:"
    head -3 public/index.html
    echo ""
    echo "📄 index.html mentions of CSS/JS:"
    grep -n "\.css\|\.js" public/index.html || echo "No CSS/JS references found"
fi
echo ""

# Check environment
echo "⚙️ Environment check:"
if [ -f ".env" ]; then
    echo "📄 .env contents:"
    cat .env
else
    echo "❌ .env file missing!"
fi
echo ""

# Check git status
echo "🔄 Git status:"
git status 2>/dev/null || echo "Not a git repository"
echo ""

# Process check
echo "🔍 Node processes:"
ps aux | grep node | grep -v grep || echo "No node processes running"
echo ""

echo "================================================="
echo "🔧 RECOMMENDED FIXES:"
echo "1. cd /var/www/secret-chat"
echo "2. pm2 stop secret-chat"
echo "3. pm2 start server.js --name secret-chat"
echo "4. pm2 logs secret-chat"
echo "5. curl http://localhost:3000"
echo "================================================="
