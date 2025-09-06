#!/bin/bash

# Quick Droplet Deployment Script
# Run this on your DigitalOcean droplet after cloning the repo

echo "🚀 Setting up Secret Chat on DigitalOcean Droplet..."

# Check if we're in the project directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Make sure you're in the project directory."
    exit 1
fi

# Install dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Create environment file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "⚙️ Creating environment file..."
    cp .env.example .env
    echo "✏️ Edit .env file with your settings:"
    echo "   - Set CLIENT_URL to your droplet IP"
    echo "   - Set PORT (default: 3000)"
    nano .env
fi

# Install PM2 globally if not installed
if ! command -v pm2 &> /dev/null; then
    echo "📊 Installing PM2 process manager..."
    npm install -g pm2
fi

# Start the application
echo "🚀 Starting Secret Chat with PM2..."
pm2 start server.js --name "secret-chat"

# Save PM2 configuration
pm2 save

# Setup PM2 startup script
echo "🔄 Setting up PM2 to start on boot..."
pm2 startup

echo ""
echo "✅ Secret Chat is now running!"
echo "📊 Check status: pm2 status"
echo "📝 View logs: pm2 logs secret-chat"
echo "🔄 Restart: pm2 restart secret-chat"
echo ""
echo "🌐 Your app should be accessible at:"
echo "   http://YOUR_DROPLET_IP:3000"
echo ""
echo "🔐 Encrypted chat ready for use!"
