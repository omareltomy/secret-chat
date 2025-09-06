#!/bin/bash

# DigitalOcean App Platform Deployment Script
# Run this script to prepare for deployment

echo "🚀 Preparing for DigitalOcean App Platform deployment..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Run this from the project root."
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository. Initialize git first."
    exit 1
fi

# Add all files
echo "📁 Adding files to git..."
git add .

# Check for uncommitted changes
if git diff --staged --quiet; then
    echo "✅ No changes to commit"
else
    echo "💾 Committing changes..."
    git commit -m "Prepare for DigitalOcean App Platform deployment"
fi

# Push to main branch
echo "⬆️  Pushing to GitHub..."
git push origin main

echo "✅ Ready for DigitalOcean deployment!"
echo ""
echo "Next steps:"
echo "1. Go to https://cloud.digitalocean.com/apps"
echo "2. Click 'Create App'"
echo "3. Choose 'GitHub' as source"
echo "4. Select your repository"
echo "5. DigitalOcean will auto-detect the configuration"
echo "6. Click 'Create Resources'"
echo ""
echo "Your app will be live at: https://your-app-name.ondigitalocean.app"
echo "🔒 Encrypted chat ready for production!"
