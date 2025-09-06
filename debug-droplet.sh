#!/bin/bash

# Debug script to check file structure and fix server issues

echo "🔍 Debugging Secret Chat deployment..."

# Check current directory
echo "📁 Current directory: $(pwd)"

# Check if files exist
echo "📋 File structure check:"
[ -f "server.js" ] && echo "✅ server.js found" || echo "❌ server.js missing"
[ -f "package.json" ] && echo "✅ package.json found" || echo "❌ package.json missing"
[ -d "public" ] && echo "✅ public directory found" || echo "❌ public directory missing"

if [ -d "public" ]; then
    [ -f "public/index.html" ] && echo "✅ public/index.html found" || echo "❌ public/index.html missing"
    [ -f "public/script.js" ] && echo "✅ public/script.js found" || echo "❌ public/script.js missing"
    [ -f "public/styles.css" ] && echo "✅ public/styles.css found" || echo "❌ public/styles.css missing"
fi

# Check if app is running
echo "🔍 Checking if app is running:"
if pgrep -f "server.js" > /dev/null; then
    echo "✅ App is running"
    echo "📊 PM2 status:"
    pm2 list
else
    echo "❌ App is not running"
fi

# Check port
echo "🌐 Checking port 3000:"
if netstat -tulpn 2>/dev/null | grep :3000 > /dev/null; then
    echo "✅ Port 3000 is in use"
else
    echo "❌ Port 3000 is not in use"
fi

# Test file serving
echo "🧪 Testing file access:"
if [ -f "public/index.html" ]; then
    echo "📄 index.html content preview:"
    head -5 public/index.html
fi

echo ""
echo "💡 Recommended fixes:"
echo "1. Make sure you're in the correct directory: cd /var/www/secret-chat"
echo "2. Restart the app: pm2 restart secret-chat"
echo "3. Check logs: pm2 logs secret-chat"
echo "4. Verify firewall: ufw status"
