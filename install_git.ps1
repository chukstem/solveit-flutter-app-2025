# Git Installation Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing Git for Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is already installed
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if ($gitPath) {
    Write-Host "[OK] Git is already installed!" -ForegroundColor Green
    git --version
    exit 0
}

Write-Host "Git is not installed." -ForegroundColor Yellow
Write-Host ""
Write-Host "Please install Git using one of these methods:" -ForegroundColor Cyan
Write-Host ""
Write-Host "METHOD 1: Download and Install" -ForegroundColor Yellow
Write-Host "  1. Go to: https://git-scm.com/download/win" -ForegroundColor Gray
Write-Host "  2. Download the installer" -ForegroundColor Gray
Write-Host "  3. Run the installer with default settings" -ForegroundColor Gray
Write-Host "  4. Restart PowerShell after installation" -ForegroundColor Gray
Write-Host ""
Write-Host "METHOD 2: Using Winget (if available)" -ForegroundColor Yellow
Write-Host "  winget install --id Git.Git -e --source winget" -ForegroundColor White
Write-Host ""
Write-Host "METHOD 3: Using Chocolatey (if installed)" -ForegroundColor Yellow
Write-Host "  choco install git -y" -ForegroundColor White
Write-Host ""

# Try to install using winget
$wingetPath = Get-Command winget -ErrorAction SilentlyContinue
if ($wingetPath) {
    Write-Host "Attempting to install Git using Winget..." -ForegroundColor Cyan
    Write-Host ""
    winget install --id Git.Git -e --source winget
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "[SUCCESS] Git installed! Please restart PowerShell and run the backup script again." -ForegroundColor Green
        exit 0
    }
}

# Try using Chocolatey
$chocoPath = Get-Command choco -ErrorAction SilentlyContinue
if ($chocoPath) {
    Write-Host "Attempting to install Git using Chocolatey..." -ForegroundColor Cyan
    Write-Host ""
    choco install git -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "[SUCCESS] Git installed! Please restart PowerShell and run the backup script again." -ForegroundColor Green
        exit 0
    }
}

Write-Host ""
Write-Host "Could not automatically install Git." -ForegroundColor Yellow
Write-Host "Please install it manually from: https://git-scm.com/download/win" -ForegroundColor Yellow
Write-Host "After installation, restart PowerShell and run the backup script again." -ForegroundColor Yellow

