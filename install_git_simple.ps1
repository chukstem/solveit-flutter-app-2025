# Simple Git Installation Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Git Installation for Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is already installed
$gitPaths = @(
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\git.exe"
)

foreach ($path in $gitPaths) {
    if (Test-Path $path) {
        Write-Host "[OK] Git is already installed at: $path" -ForegroundColor Green
        & $path --version
        Write-Host ""
        Write-Host "Git is ready to use!" -ForegroundColor Green
        Write-Host "Restart PowerShell to use Git from anywhere, or use the full path." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "Git is not installed. Starting installation..." -ForegroundColor Yellow
Write-Host ""

# Try winget installation
Write-Host "Method 1: Installing via Winget..." -ForegroundColor Cyan
Write-Host "Download size: ~63 MB" -ForegroundColor Gray
Write-Host "This will take several minutes. Please be patient..." -ForegroundColor Gray
Write-Host ""

$process = Start-Process -FilePath "winget" -ArgumentList "install","--id","Git.Git","-e","--source","winget","--accept-package-agreements","--accept-source-agreements" -NoNewWindow -PassThru -Wait

if ($process.ExitCode -eq 0) {
    Write-Host ""
    Write-Host "[SUCCESS] Git installed successfully!" -ForegroundColor Green
    
    # Refresh PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Check installation
    Start-Sleep -Seconds 2
    $gitCheck = Get-Command git -ErrorAction SilentlyContinue
    if ($gitCheck) {
        git --version
        Write-Host ""
        Write-Host "Git is ready to use!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "[INFO] Git installed but may require PowerShell restart." -ForegroundColor Yellow
        Write-Host "Please restart PowerShell and verify with: git --version" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "[ERROR] Installation failed or was interrupted." -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative options:" -ForegroundColor Yellow
    Write-Host "1. Manual download: https://git-scm.com/download/win" -ForegroundColor White
    Write-Host "2. Or try again by running this script" -ForegroundColor White
}

