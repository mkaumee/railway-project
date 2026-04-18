$ErrorActionPreference = "Stop"

$repo = "m.kaumee/gogcli"
$file = "gog-windows-amd64.exe"
$url = "https://github.com/$repo/releases/latest/download/$file"

Write-Host "Downloading gog CLI..." -ForegroundColor Cyan

$dest = "$env:USERPROFILE\gog.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    
    Write-Host ""
    Write-Host "Installed gog to $dest" -ForegroundColor Green
    Write-Host ""
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Get started:"
    Write-Host "  gog auth add your-email@gmail.com"
    Write-Host ""
    Write-Host "For help:"
    Write-Host "  gog --help"
    Write-Host ""
    Write-Host "Note: Add $env:USERPROFILE to your PATH to run 'gog' from anywhere" -ForegroundColor Yellow
    
} catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}
