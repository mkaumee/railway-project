$ErrorActionPreference = "Stop"

$repo = "mkaumee/gog-cli"
$file = "gog-windows-amd64.exe"
$url = "https://github.com/$repo/releases/latest/download/$file"

Write-Host "Downloading gog CLI..." -ForegroundColor Cyan

# Install to a better location
$installDir = "$env:LOCALAPPDATA\Programs\gog"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
$dest = "$installDir\gog.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    
    Write-Host ""
    Write-Host "Installed gog to $dest" -ForegroundColor Green
    
    # Add to PATH if not already there
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$installDir*") {
        Write-Host "Adding to PATH..." -ForegroundColor Yellow
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$userPath;$installDir",
            "User"
        )
        $env:Path = "$env:Path;$installDir"
        Write-Host "Added to PATH" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Get started:"
    Write-Host "  gog auth add your-email@gmail.com"
    Write-Host ""
    Write-Host "For help:"
    Write-Host "  gog --help"
    Write-Host ""
    Write-Host "Note: Restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
    
} catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}
