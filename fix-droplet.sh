#!/bin/bash

# Quick Fix for Droplet 404 Issues
echo "🔧 Fixing Secret Chat deployment issues..."

# Check current directory
echo "📁 Current directory: $(pwd)"

# Stop any running instances
echo "🛑 Stopping any running instances..."
pm2 stop secret-chat 2>/dev/null || echo "No PM2 process to stop"
pkill -f "node.*server.js" 2>/dev/null || echo "No node processes to kill"

# Check if we're in the right directory
if [ ! -f "server.js" ] || [ ! -f "package.json" ]; then
    echo "❌ Error: Not in project directory!"
    echo "💡 Navigate to: cd /var/www/secret-chat"
    exit 1
fi

# Verify file structure
echo "📋 Verifying file structure..."
required_files=("server.js" "package.json" "public/index.html" "public/script.js" "public/styles.css")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file found"
    else
        echo "❌ $file missing!"
        exit 1
    fi
done

# Install/update dependencies
echo "📦 Installing dependencies..."
npm install

# Create/update environment file
if [ ! -f ".env" ]; then
    echo "⚙️ Creating .env file..."
    cp .env.example .env
    
    # Get server IP
    SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "YOUR_DROPLET_IP")
    
    # Update .env with correct IP
    sed -i "s/YOUR_DROPLET_IP/$SERVER_IP/g" .env
    echo "🌐 Updated CLIENT_URL to: http://$SERVER_IP:3000"
    
    # Show .env content
    echo "📄 Environment configuration:"
    cat .env
fi

# Start with PM2
echo "🚀 Starting Secret Chat..."
pm2 start server.js --name "secret-chat" --watch

# Save PM2 config
pm2 save

# Show status
echo "📊 Application status:"
pm2 status

# Show logs
echo "📝 Recent logs:"
pm2 logs secret-chat --lines 10

# Test the server
sleep 3
echo "🧪 Testing server response..."
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ Server is responding!"
else
    echo "❌ Server not responding. Check logs: pm2 logs secret-chat"
fi

echo ""
echo "🎉 Setup complete!"
echo "🌐 Your app should be accessible at: http://$(curl -s ifconfig.me):3000"
echo "📊 Monitor with: pm2 monit"
echo "📝 Check logs: pm2 logs secret-chat"
