# Gmail CLI Installer - Railway Deployment

Simple Express server to host install scripts for the Gmail CLI.

## Setup

1. Update `install.sh` and `install.ps1` with your GitHub username
2. Deploy to Railway
3. Get your Railway URL
4. Use in your desktop app

## Local Testing

```bash
npm install
npm start
```

Visit http://localhost:3000 to see available endpoints.

## Deploy to Railway

1. Push this folder to GitHub
2. Go to [railway.app](https://railway.app)
3. Create new project from GitHub repo
4. Railway auto-deploys
5. Click "Generate Domain"

## Endpoints

- `/` - Info and health check
- `/install.sh` - macOS/Linux installer
- `/install.ps1` - Windows installer

## Usage

**macOS/Linux:**
```bash
curl -fsSL https://your-app.up.railway.app/install.sh | bash
```

**Windows:**
```powershell
iwr https://your-app.up.railway.app/install.ps1 | iex
```

## Custom Domain

Add custom domain in Railway settings:
- `cli.yourdomain.com`

Then use:
```bash
curl -fsSL https://cli.yourdomain.com/install.sh | bash
```
