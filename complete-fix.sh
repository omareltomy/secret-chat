#!/bin/bash

# Complete Fix for 404 Issues on Droplet
echo "🔧 FIXING Secret Chat 404 errors..."
echo "====================================="

# Kill any existing processes
echo "🛑 Killing existing processes..."
pm2 delete secret-chat 2>/dev/null || echo "No PM2 process to delete"
pkill -f "node.*server" 2>/dev/null || echo "No node processes to kill"
sleep 2

# Navigate to correct directory
if [ ! -d "/var/www/secret-chat" ]; then
    echo "❌ /var/www/secret-chat not found!"
    echo "🔍 Current directory: $(pwd)"
    echo "📂 Available directories in /var/www:"
    ls -la /var/www/ 2>/dev/null || echo "No /var/www directory"
    
    # Try to find the project
    echo "🔍 Searching for secret-chat..."
    find / -name "secret-chat" -type d 2>/dev/null | head -5
    exit 1
fi

cd /var/www/secret-chat
echo "📍 Working in: $(pwd)"

# Verify all files exist
echo "📋 Checking files..."
if [ ! -f "server.js" ]; then
    echo "❌ server.js missing! Re-cloning repository..."
    cd /var/www
    rm -rf secret-chat
    git clone https://github.com/omareltomy/secret-chat.git
    cd secret-chat
fi

# Ensure public directory has correct permissions
echo "🔧 Setting permissions..."
chmod -R 755 public/
chown -R www-data:www-data public/ 2>/dev/null || echo "Could not change ownership (not critical)"

# Install dependencies
echo "📦 Installing dependencies..."
npm install --production

# Create/fix environment file
echo "⚙️ Setting up environment..."
if [ ! -f ".env" ]; then
    cp .env.example .env
fi

# Get server IP and update .env
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "167.99.39.193")
echo "🌐 Server IP detected: $SERVER_IP"

# Update .env file
cat > .env << EOF
NODE_ENV=production
PORT=3000
CLIENT_URL=http://$SERVER_IP:3000
EOF

echo "📄 Environment configuration:"
cat .env

# Test file structure
echo "📂 Verifying file structure..."
required_files=("server.js" "package.json" "public/index.html" "public/script.js" "public/styles.css")
missing_files=()

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file ($(stat -c%s "$file") bytes)"
    else
        echo "❌ $file MISSING!"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo "💥 Critical files missing! Re-cloning repository..."
    cd /var/www
    rm -rf secret-chat
    git clone https://github.com/omareltomy/secret-chat.git
    cd secret-chat
    cp .env.example .env
    sed -i "s/YOUR_DROPLET_IP/$SERVER_IP/g" .env
    npm install --production
fi

# Start the server with verbose logging
echo "🚀 Starting Secret Chat server..."
NODE_ENV=production npm start &
SERVER_PID=$!
echo "📝 Server started with PID: $SERVER_PID"

# Wait a moment for server to start
sleep 3

# Test the server
echo "🧪 Testing server..."
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ Server health check passed!"
else
    echo "❌ Server health check failed!"
    echo "📝 Server output:"
    ps aux | grep node
fi

# Test static file serving
echo "🧪 Testing static files..."
test_files=("/" "/styles.css" "/script.js")
for path in "${test_files[@]}"; do
    status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000$path)
    if [ "$status" = "200" ]; then
        echo "✅ $path responds with 200"
    else
        echo "❌ $path responds with $status"
    fi
done

# Setup PM2 for production
echo "📊 Setting up PM2..."
kill $SERVER_PID 2>/dev/null
pm2 start server.js --name "secret-chat" --env production
pm2 save
pm2 startup

echo ""
echo "====================================="
echo "🎉 SECRET CHAT DEPLOYMENT COMPLETE!"
echo "====================================="
echo "🌐 Access your app at: http://$SERVER_IP:3000"
echo "📊 Monitor with: pm2 monit"
echo "📝 Check logs: pm2 logs secret-chat"
echo "🔄 Restart: pm2 restart secret-chat"
echo "====================================="
