@echo off
echo 🚀 Preparing for DigitalOcean App Platform deployment...

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: package.json not found. Run this from the project root.
    pause
    exit /b 1
)

REM Check if git is initialized
if not exist ".git" (
    echo ❌ Error: Not a git repository. Initialize git first.
    pause
    exit /b 1
)

REM Add all files
echo 📁 Adding files to git...
git add .

REM Check for uncommitted changes and commit
git diff --staged --quiet
if %errorlevel% neq 0 (
    echo 💾 Committing changes...
    git commit -m "Prepare for DigitalOcean App Platform deployment"
) else (
    echo ✅ No changes to commit
)

REM Push to main branch
echo ⬆️  Pushing to GitHub...
git push origin main

echo ✅ Ready for DigitalOcean deployment!
echo.
echo Next steps:
echo 1. Go to https://cloud.digitalocean.com/apps
echo 2. Click 'Create App'
echo 3. Choose 'GitHub' as source
echo 4. Select your repository
echo 5. DigitalOcean will auto-detect the configuration
echo 6. Click 'Create Resources'
echo.
echo Your app will be live at: https://your-app-name.ondigitalocean.app
echo 🔒 Encrypted chat ready for production!
pause
