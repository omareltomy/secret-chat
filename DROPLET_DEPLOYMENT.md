# Deploy to DigitalOcean Droplet with Git Clone

## Prerequisites
- DigitalOcean Droplet (Ubuntu 20.04+ recommended)
- SSH access to your droplet
- GitHub repository with your code

## Step 1: Connect to Your Droplet
```bash
ssh root@YOUR_DROPLET_IP
```

## Step 2: Update System & Install Dependencies
```bash
# Update system
apt update && apt upgrade -y

# Install Node.js (v18+)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Install PM2 for process management
npm install -g pm2

# Install Git (if not installed)
apt install git -y

# Verify installations
node --version
npm --version
git --version
```

## Step 3: Clone Your Repository
```bash
# Navigate to web directory
cd /var/www

# Clone your repository
git clone https://github.com/omareltomy/secret-chat.git

# Navigate to project
cd secret-chat

# Install dependencies
npm install
```

## Step 4: Configure Environment
```bash
# Create production environment file
cp .env.example .env

# Edit environment variables
nano .env
```

Set these variables in `.env`:
```
NODE_ENV=production
PORT=3000
CLIENT_URL=http://YOUR_DROPLET_IP:3000
```

## Step 5: Configure Firewall
```bash
# Allow SSH (if not already allowed)
ufw allow ssh

# Allow HTTP and HTTPS
ufw allow 80
ufw allow 443

# Allow your app port (3000)
ufw allow 3000

# Enable firewall
ufw enable
```

## Step 6: Start the Application
```bash
# Start with PM2
pm2 start server.js --name "secret-chat"

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
# Follow the command it gives you (usually starts with 'sudo env PATH=...')
```

## Step 7: Access Your App
Your encrypted chat app is now live at:
```
http://YOUR_DROPLET_IP:3000
```

## Step 8: Optional - Setup Nginx Reverse Proxy
```bash
# Install Nginx
apt install nginx -y

# Create Nginx configuration
nano /etc/nginx/sites-available/secret-chat
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name YOUR_DROPLET_IP;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Enable the site
ln -s /etc/nginx/sites-available/secret-chat /etc/nginx/sites-enabled/

# Test Nginx configuration
nginx -t

# Restart Nginx
systemctl restart nginx
```

Now access at: `http://YOUR_DROPLET_IP`

## Useful Commands

### Check App Status
```bash
pm2 status
pm2 logs secret-chat
```

### Update App
```bash
cd /var/www/secret-chat
git pull origin main
npm install
pm2 restart secret-chat
```

### Monitor Resources
```bash
pm2 monit
htop
```

### Troubleshooting
```bash
# Check if port is being used
netstat -tulpn | grep :3000

# Check PM2 logs
pm2 logs secret-chat --lines 50

# Restart app
pm2 restart secret-chat
```

## Security Notes
- Change default SSH port
- Use SSH keys instead of passwords
- Setup fail2ban for brute force protection
- Consider using a domain name with SSL certificate
- Regular security updates: `apt update && apt upgrade`

Your encrypted chat app is now running on your DigitalOcean droplet! 🚀
