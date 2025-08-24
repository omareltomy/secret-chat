# Deployment Guide - Render

## Prerequisites
- GitHub account
- Render account (free at render.com)
- Your code pushed to GitHub

## Step 1: Prepare for Render Deployment

Your project is already configured for Render with the current setup!

## Step 2: Deploy on Render

1. **Sign up at [render.com](https://render.com)**
2. **Connect your GitHub account**
3. **Click "New" → "Web Service"**
4. **Connect your repository**
5. **Configure the service:**
   - **Name**: `secure-chat-app` (or your preferred name)
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free (or paid for better performance)

## Step 3: Environment Variables (Optional)

In Render dashboard, add these environment variables:
- `NODE_ENV` = `production`
- `CLIENT_URL` = `https://your-actual-app-name.onrender.com` (replace with your actual URL)
- `PORT` = (leave empty, Render sets this automatically)

**Note**: The `CLIENT_URL` should match your actual Render app URL for CORS to work properly.

## Step 4: Deploy

Click "Create Web Service" and Render will:
- Install dependencies
- Start your server
- Provide a live URL like `https://your-app-name.onrender.com`

## Step 5: Test Your Deployment

1. Visit your Render URL
2. Create a room and copy the link
3. Open the link in another browser/device
4. Test encrypted messaging!

## Render-Specific Features

✅ **Automatic HTTPS** - Built-in SSL certificates
✅ **Auto-deploys** - Deploys on every GitHub push
✅ **Health checks** - Built-in monitoring
✅ **Custom domains** - Add your own domain
✅ **Environment management** - Easy env var setup

## Troubleshooting

**If deployment fails:**
1. Check build logs in Render dashboard
2. Ensure `package.json` has all dependencies
3. Verify `npm start` works locally

**If WebSocket connections fail:**
- Render supports WebSocket by default
- No additional configuration needed

## Performance Tips

- **Free tier**: App sleeps after 15 min of inactivity
- **Paid tier**: Always-on, faster cold starts
- **Custom domain**: Better for production use

Your encrypted chat app will be live in 2-3 minutes! 🚀
