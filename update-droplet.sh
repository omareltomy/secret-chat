#!/bin/bash

# Update Secret Chat on DigitalOcean Droplet
echo "🔄 Updating Secret Chat on droplet..."

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -d ".git" ]; then
    echo "❌ Error: Not in project directory or not a git repo!"
    echo "💡 Navigate to: cd /var/www/secret-chat"
    exit 1
fi

# Stop the app
echo "🛑 Stopping Secret Chat..."
pm2 stop secret-chat

# Backup current .env (in case we need it)
if [ -f ".env" ]; then
    cp .env .env.backup
    echo "💾 Backed up .env file"
fi

# Pull latest changes
echo "⬇️ Pulling latest code from GitHub..."
git fetch origin
git reset --hard origin/main

# Restore .env if it exists
if [ -f ".env.backup" ]; then
    cp .env.backup .env
    echo "♻️ Restored .env file"
fi

# Install any new dependencies
echo "📦 Installing/updating dependencies..."
npm install

# Restart the app
echo "🚀 Restarting Secret Chat..."
pm2 start secret-chat

# Show status
echo "📊 Current status:"
pm2 status

# Show recent logs
echo "📝 Recent logs:"
pm2 logs secret-chat --lines 5

echo ""
echo "✅ Update complete!"
echo "🌐 Your app is running at: http://$(curl -s ifconfig.me):3000"
