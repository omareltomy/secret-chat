# 🚀 DigitalOcean Deployment Guide

## Quick Deployment (Recommended)

### DigitalOcean App Platform

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Production ready"
   git push origin main
   ```

2. **Deploy on DigitalOcean**
   - Go to [DigitalOcean Apps](https://cloud.digitalocean.com/apps)
   - Click "Create App"
   - Connect your GitHub repository
   - Select this repository and the `main` branch
   - DigitalOcean will auto-detect the configuration
   - Click "Create Resources"

3. **Configuration is Automatic**
   - The `.do/app.yaml` file contains all settings
   - Environment variables are pre-configured
   - Health checks are enabled
   - Auto-scaling is ready

### Expected Costs
- **Basic Plan**: $5/month (512MB RAM, 1 vCPU)
- **Professional**: $12/month (1GB RAM, 1 vCPU)

## Manual Droplet Deployment

### 1. Create Droplet
- **OS**: Ubuntu 22.04 LTS
- **Size**: Basic $6/month (1GB RAM)
- **Region**: Choose closest to your users

### 2. Setup Server
```bash
# SSH into your droplet
ssh root@your-droplet-ip

# Update system
apt update && apt upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Install PM2 for process management
npm install -g pm2

# Create app user
adduser chatapp
usermod -aG sudo chatapp
su - chatapp
```

### 3. Deploy Application
```bash
# Clone your repository
git clone https://github.com/yourusername/secure-chat-app.git
cd secure-chat-app

# Install dependencies
npm install --production

# Set environment variables
echo "NODE_ENV=production" > .env
echo "PORT=3000" >> .env
echo "CLIENT_URL=http://your-droplet-ip:3000" >> .env

# Start with PM2
pm2 start server.js --name "chat-app"
pm2 startup
pm2 save
```

### 4. Configure Firewall (Optional)
```bash
# Enable UFW
ufw enable

# Allow SSH and HTTP
ufw allow ssh
ufw allow 3000
ufw allow 80
ufw allow 443
```

### 5. Setup Nginx (Optional)
```bash
# Install Nginx
sudo apt install nginx

# Create Nginx config
sudo tee /etc/nginx/sites-available/chatapp << EOF
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/chatapp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Monitoring & Maintenance

### Check Application Status
```bash
pm2 status
pm2 logs chat-app
```

### Update Application
```bash
cd secure-chat-app
git pull origin main
npm install --production
pm2 restart chat-app
```

### Monitor Resources
```bash
htop
df -h
free -h
```

## Troubleshooting

### Common Issues

1. **Port 3000 not accessible**
   - Check firewall: `ufw status`
   - Verify app is running: `pm2 status`

2. **Application crashes**
   - Check logs: `pm2 logs chat-app`
   - Restart: `pm2 restart chat-app`

3. **Out of memory**
   - Upgrade droplet size
   - Check for memory leaks: `pm2 monit`

### Health Check
Your app includes a health endpoint at `/health` that returns:
```json
{
  "status": "OK",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uptime": 3600.5
}
```

## Security Best Practices

1. **SSH Keys**: Use SSH keys instead of passwords
2. **Firewall**: Only open necessary ports
3. **Updates**: Keep system updated
4. **Monitoring**: Set up alerts for downtime
5. **Backups**: Regular droplet snapshots

## Support

- **DigitalOcean Docs**: [App Platform](https://docs.digitalocean.com/products/app-platform/)
- **Community**: [DigitalOcean Community](https://www.digitalocean.com/community/)
- **Support**: Available with paid plans
