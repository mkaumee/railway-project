# PowerShell uninstall script for gog CLI
$ErrorActionPreference = "Stop"

Write-Host "Uninstalling gog CLI..." -ForegroundColor Cyan

# Common installation locations
$locations = @(
    "$env:USERPROFILE\gog.exe",
    "$env:LOCALAPPDATA\Programs\gogcli\gog.exe",
    "C:\Windows\System32\gog.exe",
    "C:\Program Files\gog\gog.exe"
)

$found = $false

foreach ($location in $locations) {
    if (Test-Path $location) {
        Write-Host "Removing $location..." -ForegroundColor Yellow
        try {
            Remove-Item $location -Force
            Write-Host "OK: Removed $location" -ForegroundColor Green
            $found = $true
        } catch {
            Write-Host "ERROR: Could not remove $location - $_" -ForegroundColor Red
        }
    }
}

if (-not $found) {
    Write-Host "WARNING: gog.exe not found in common locations" -ForegroundColor Yellow
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
