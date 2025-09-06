# DigitalOcean App Platform Deployment Guide

## Prerequisites
- DigitalOcean account
- GitHub account with your code pushed
- Credit card (for verification, free tier available)

## Method 1: Automatic Deployment (Recommended)

### Step 1: Prepare Repository
Your code is already configured for DigitalOcean! The `.do/app.yaml` file contains all necessary settings.

### Step 2: Deploy via DigitalOcean Dashboard

1. **Log into [DigitalOcean](https://cloud.digitalocean.com/)**
2. **Go to "Apps" in the left sidebar**
3. **Click "Create App"**
4. **Choose "GitHub" as source**
5. **Connect your GitHub account**
6. **Select your repository: `secret-chat`**
7. **Choose branch: `main`**
8. **DigitalOcean will auto-detect the app.yaml configuration**
9. **Review settings and click "Create Resources"**

### Step 3: Configuration (Auto-configured)
- **Build Command**: `npm install` ✅
- **Run Command**: `npm start` ✅
- **Environment**: Node.js ✅
- **Health Check**: `/health` endpoint ✅
- **Auto-scaling**: Enabled ✅

## Method 2: Manual Configuration

If auto-detection doesn't work:

1. **Create App** → **From Source Code**
2. **Connect GitHub repository**
3. **Configure manually**:
   - **Type**: Web Service
   - **Build Command**: `npm install`
   - **Run Command**: `npm start`
   - **HTTP Port**: 3000
   - **Environment Variables**:
     - `NODE_ENV` = `production`
     - `CLIENT_URL` = `${APP_URL}` (auto-generated)

## Step 4: Environment Variables

DigitalOcean will automatically set:
- `PORT` (automatically assigned)
- `APP_URL` (your app's URL)

Optional variables you can add:
- `CLIENT_URL` = your app URL (for additional CORS control)

## Step 5: Custom Domain (Optional)

1. **Go to your app settings**
2. **Click "Domains"**
3. **Add your custom domain**
4. **Update DNS records as instructed**

## Deployment Features

✅ **Automatic HTTPS** - SSL certificates included
✅ **Auto-scaling** - Scales based on traffic
✅ **Global CDN** - Fast worldwide access
✅ **Health monitoring** - Built-in health checks
✅ **Auto-deploys** - Deploys on every Git push
✅ **WebSocket support** - Perfect for Socket.io
✅ **Zero-downtime deploys** - No service interruption

## Pricing

- **Basic (512MB RAM)**: $5/month
- **Professional (1GB RAM)**: $12/month
- **Free trial**: $100 credit for 60 days

## Your App URLs

After deployment, your app will be available at:
- **Primary**: `https://your-app-name.ondigitalocean.app`
- **Alternative**: `https://your-app-name-xyz.ondigitalocean.app`

## Troubleshooting

### Build Fails
- Check that `package.json` has all dependencies
- Verify `npm install` works locally
- Check build logs in DigitalOcean console

### WebSocket Issues
- DigitalOcean supports WebSockets by default
- No additional configuration needed

### CORS Errors
- App is pre-configured for DigitalOcean domains
- Update `CLIENT_URL` if using custom domain

## Monitoring

- **Logs**: Available in DigitalOcean console
- **Metrics**: CPU, memory, and request metrics
- **Alerts**: Set up alerts for downtime or high usage

## Estimated Deployment Time: 3-5 minutes

Your encrypted chat app will be live with enterprise-grade infrastructure! 🚀
