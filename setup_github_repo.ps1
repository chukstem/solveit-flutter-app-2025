# Complete GitHub Repository Setup Script
# This script will initialize Git, commit files, and create a GitHub repository

param(
    [string]$RepoName = "solveit-flutter-app-2025",
    [string]$GitHubUsername = "",
    [string]$GitHubToken = "",
    [string]$Description = "SolveIt Flutter app with Laravel backend integration"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Repository Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Git Installation
Write-Host "Step 1: Checking Git installation..." -ForegroundColor Yellow
$gitPath = $null
$commonPaths = @(
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\git.exe",
    "$env:ProgramFiles\Git\cmd\git.exe"
)

foreach ($path in $commonPaths) {
    if (Test-Path $path) {
        $gitPath = Split-Path $path -Parent
        $env:PATH = "$gitPath;$env:PATH"
        break
    }
}

# Try to find git in PATH
try {
    $null = Get-Command git -ErrorAction Stop
    $gitPath = "Found in PATH"
} catch {
    Write-Host "   [ERROR] Git is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Please install Git:" -ForegroundColor Yellow
    Write-Host "   1. Download from: https://git-scm.com/download/win" -ForegroundColor Gray
    Write-Host "   2. Install with default settings" -ForegroundColor Gray
    Write-Host "   3. Restart PowerShell" -ForegroundColor Gray
    Write-Host "   4. Run this script again" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   Or run: winget install --id Git.Git -e --source winget" -ForegroundColor Cyan
    exit 1
}

$gitVersion = git --version
Write-Host "   [OK] Git found: $gitVersion" -ForegroundColor Green
Write-Host ""

# Step 2: Configure Git User (if not already configured)
Write-Host "Step 2: Configuring Git user..." -ForegroundColor Yellow
$currentUser = git config user.name 2>&1
if ($LASTEXITCODE -ne 0 -or -not $currentUser) {
    Write-Host "   Git user not configured. Using defaults..." -ForegroundColor Yellow
    Write-Host "   (You can configure later with: git config user.name 'Your Name')" -ForegroundColor Gray
    Write-Host "   (You can configure later with: git config user.email 'your.email@example.com')" -ForegroundColor Gray
} else {
    Write-Host "   [OK] Git user: $currentUser" -ForegroundColor Green
}
Write-Host ""

# Step 3: Initialize Git Repository
Write-Host "Step 3: Initializing Git repository..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "   [INFO] Git repository already exists" -ForegroundColor Yellow
} else {
    git init
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Git repository initialized" -ForegroundColor Green
    } else {
        Write-Host "   [ERROR] Failed to initialize Git repository" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Step 4: Stage All Files
Write-Host "Step 4: Staging files..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -eq 0) {
    $stagedFiles = git diff --cached --name-only
    $fileCount = ($stagedFiles | Measure-Object -Line).Lines
    Write-Host "   [OK] Staged $fileCount files" -ForegroundColor Green
} else {
    Write-Host "   [WARNING] Some issues staging files" -ForegroundColor Yellow
}
Write-Host ""

# Step 5: Create Initial Commit
Write-Host "Step 5: Creating initial commit..." -ForegroundColor Yellow
$hasUncommitted = git diff --cached --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    git commit -m "Initial commit: $Description"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Initial commit created" -ForegroundColor Green
    } else {
        Write-Host "   [ERROR] Failed to create commit" -ForegroundColor Red
        Write-Host "   You may need to configure Git user first:" -ForegroundColor Yellow
        Write-Host "   git config user.name 'Your Name'" -ForegroundColor Gray
        Write-Host "   git config user.email 'your.email@example.com'" -ForegroundColor Gray
        exit 1
    }
} else {
    Write-Host "   [INFO] Nothing to commit" -ForegroundColor Yellow
}
Write-Host ""

# Step 6: Set Branch to Main
Write-Host "Step 6: Setting branch to 'main'..." -ForegroundColor Yellow
git branch -M main 2>&1 | Out-Null
Write-Host "   [OK] Branch set to 'main'" -ForegroundColor Green
Write-Host ""

# Step 7: Create GitHub Repository
Write-Host "Step 7: Creating GitHub repository..." -ForegroundColor Yellow

# Check if GitHub CLI is available
$ghAvailable = $false
try {
    $null = Get-Command gh -ErrorAction Stop
    $ghAvailable = $true
} catch {
    $ghAvailable = $false
}

if ($ghAvailable) {
    Write-Host "   [INFO] GitHub CLI (gh) found. Using it to create repository..." -ForegroundColor Cyan
    
    # Check if authenticated
    $ghAuthStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   [INFO] Not authenticated with GitHub CLI" -ForegroundColor Yellow
        Write-Host "   Please authenticate first:" -ForegroundColor Yellow
        Write-Host "   gh auth login" -ForegroundColor White
        Write-Host ""
        Write-Host "   Then run this script again, or continue manually:" -ForegroundColor Cyan
    } else {
        Write-Host "   [OK] Authenticated with GitHub CLI" -ForegroundColor Green
        
        # Create repository
        Write-Host "   Creating repository '$RepoName' on GitHub..." -ForegroundColor Cyan
        if ($Description) {
            gh repo create $RepoName --public --description $Description --source=. --remote=origin --push
        } else {
            gh repo create $RepoName --public --source=. --remote=origin --push
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "   [SUCCESS] Repository created and pushed to GitHub!" -ForegroundColor Green
            $repoUrl = gh repo view $RepoName --web -q .url 2>&1
            Write-Host "   Repository URL: $repoUrl" -ForegroundColor Cyan
            exit 0
        } else {
            Write-Host "   [WARNING] Failed to create repository with GitHub CLI" -ForegroundColor Yellow
        }
    }
}

# Fallback: Manual instructions
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps (Manual)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Since GitHub CLI is not available or not authenticated," -ForegroundColor Yellow
Write-Host "please create the repository manually:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to https://github.com/new" -ForegroundColor White
Write-Host "2. Repository name: $RepoName" -ForegroundColor White
Write-Host "3. Description: $Description" -ForegroundColor White
Write-Host "4. Choose Public or Private" -ForegroundColor White
Write-Host "5. DO NOT initialize with README, .gitignore, or license" -ForegroundColor Yellow
Write-Host "6. Click 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "Then run these commands:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   git remote add origin https://github.com/YOUR_USERNAME/$RepoName.git" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "Note: You'll need a Personal Access Token as password when pushing." -ForegroundColor Gray
Write-Host "Get one at: https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host ""

# If GitHub username is provided, show the exact command
if ($GitHubUsername) {
    Write-Host "   Or use this command:" -ForegroundColor Cyan
    Write-Host "   git remote add origin https://github.com/$GitHubUsername/$RepoName.git" -ForegroundColor White
    Write-Host "   git push -u origin main" -ForegroundColor White
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

