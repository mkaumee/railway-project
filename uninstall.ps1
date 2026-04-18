# PowerShell uninstall script for gog CLI
$ErrorActionPreference = "Stop"

Write-Host "Uninstalling gog CLI..." -ForegroundColor Cyan

# Installation location
$installDir = "$env:LOCALAPPDATA\Programs\gog"
$gogExe = "$installDir\gog.exe"

# Also check old location
$oldLocation = "$env:USERPROFILE\gog.exe"

$found = $false

# Remove from new location
if (Test-Path $gogExe) {
    Write-Host "Removing $gogExe..." -ForegroundColor Yellow
    try {
        Remove-Item $gogExe -Force
        Write-Host "OK: Removed $gogExe" -ForegroundColor Green
        $found = $true
    } catch {
        Write-Host "ERROR: Could not remove $gogExe - $_" -ForegroundColor Red
    }
}

# Remove from old location
if (Test-Path $oldLocation) {
    Write-Host "Removing $oldLocation..." -ForegroundColor Yellow
    try {
        Remove-Item $oldLocation -Force
        Write-Host "OK: Removed $oldLocation" -ForegroundColor Green
        $found = $true
    } catch {
        Write-Host "ERROR: Could not remove $oldLocation - $_" -ForegroundColor Red
    }
}

# Remove from PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -like "*$installDir*") {
    Write-Host "Removing from PATH..." -ForegroundColor Yellow
    $newPath = ($userPath -split ';' | Where-Object { $_ -ne $installDir }) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "OK: Removed from PATH" -ForegroundColor Green
}

# Remove install directory if empty
if (Test-Path $installDir) {
    $items = Get-ChildItem $installDir -ErrorAction SilentlyContinue
    if ($items.Count -eq 0) {
        Remove-Item $installDir -Force -ErrorAction SilentlyContinue
    }
}

if (-not $found) {
    Write-Host "WARNING: gog.exe not found" -ForegroundColor Yellow
}

# Ask about config/credentials
Write-Host ""
$response = Read-Host "Remove stored credentials and config? (y/N)"

if ($response -eq 'y' -or $response -eq 'Y') {
    $configDir = "$env:APPDATA\gogcli"
    
    if (Test-Path $configDir) {
        Write-Host "Removing $configDir..." -ForegroundColor Yellow
        Remove-Item $configDir -Recurse -Force
        Write-Host "OK: Config and credentials removed" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Config directory not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "INFO: Keeping config and credentials" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Uninstall complete!" -ForegroundColor Green
Write-Host "Note: Restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
