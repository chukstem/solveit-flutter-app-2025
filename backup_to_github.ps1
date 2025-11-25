# GitHub Backup Script for SolveIt Flutter App
# This script helps backup your project to GitHub

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Backup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if git is installed
Write-Host "1. Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "   [OK] Git is installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Git is not installed!" -ForegroundColor Red
    Write-Host "   Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Check if this is already a git repository
Write-Host "2. Checking Git repository status..." -ForegroundColor Yellow
$isGitRepo = Test-Path ".git"

if ($isGitRepo) {
    Write-Host "   [OK] Git repository already exists" -ForegroundColor Green
    
    # Check for existing remote
    $remote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Remote repository: $remote" -ForegroundColor Green
    } else {
        Write-Host "   [INFO] No remote repository configured" -ForegroundColor Yellow
    }
} else {
    Write-Host "   [INFO] Initializing new Git repository..." -ForegroundColor Yellow
    git init
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Git repository initialized" -ForegroundColor Green
    } else {
        Write-Host "   [ERROR] Failed to initialize Git repository" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Check current branch
Write-Host "3. Checking current branch..." -ForegroundColor Yellow
$currentBranch = git branch --show-current 2>&1
if ($LASTEXITCODE -eq 0 -and $currentBranch) {
    Write-Host "   [OK] Current branch: $currentBranch" -ForegroundColor Green
} else {
    Write-Host "   [INFO] No commits yet. Will create initial commit on 'main' branch" -ForegroundColor Yellow
    $currentBranch = "main"
}

Write-Host ""

# Show status
Write-Host "4. Checking repository status..." -ForegroundColor Yellow
git status --short
$statusOutput = git status --porcelain 2>&1

if ($statusOutput -match "^\?\?" -or $statusOutput.Length -gt 0) {
    Write-Host "   [INFO] There are uncommitted changes" -ForegroundColor Yellow
} else {
    Write-Host "   [OK] Working directory is clean" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Ready to Backup to GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Instructions
Write-Host "To complete the backup, follow these steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "OPTION 1: If you DON'T have a GitHub repository yet:" -ForegroundColor Cyan
Write-Host "  1. Go to https://github.com and create a new repository" -ForegroundColor Gray
Write-Host "  2. Do NOT initialize it with README, .gitignore, or license" -ForegroundColor Gray
Write-Host "  3. Copy the repository URL (e.g., https://github.com/username/repo.git)" -ForegroundColor Gray
Write-Host "  4. Run this script again with the repository URL:" -ForegroundColor Gray
Write-Host "     .\backup_to_github.ps1 -RepoUrl https://github.com/username/repo.git" -ForegroundColor White
Write-Host ""
Write-Host "OPTION 2: If you already have a GitHub repository:" -ForegroundColor Cyan
Write-Host "  1. Run this script with your repository URL:" -ForegroundColor Gray
Write-Host "     .\backup_to_github.ps1 -RepoUrl https://github.com/username/repo.git" -ForegroundColor White
Write-Host ""
Write-Host "OPTION 3: Manual steps (if script doesn't work):" -ForegroundColor Cyan
Write-Host "  1. git add ." -ForegroundColor White
Write-Host "  2. git commit -m 'Initial commit: SolveIt Flutter app'" -ForegroundColor White
Write-Host "  3. git branch -M main" -ForegroundColor White
Write-Host "  4. git remote add origin https://github.com/username/repo.git" -ForegroundColor White
Write-Host "  5. git push -u origin main" -ForegroundColor White
Write-Host ""

# Check if RepoUrl parameter was provided
param(
    [string]$RepoUrl = ""
)

if ($RepoUrl) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Backing up to GitHub..." -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Add remote if not exists
    $existingRemote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Adding remote repository..." -ForegroundColor Yellow
        git remote add origin $RepoUrl
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   [OK] Remote added" -ForegroundColor Green
        } else {
            Write-Host "   [ERROR] Failed to add remote" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Updating remote URL..." -ForegroundColor Yellow
        git remote set-url origin $RepoUrl
        Write-Host "   [OK] Remote URL updated" -ForegroundColor Green
    }
    
    Write-Host ""
    
    # Stage all files
    Write-Host "Staging files..." -ForegroundColor Yellow
    git add .
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Files staged" -ForegroundColor Green
    } else {
        Write-Host "   [WARNING] Some files may not have been staged" -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # Check if there are changes to commit
    $statusOutput = git status --porcelain 2>&1
    if ($statusOutput -match "^\?\?" -or ($statusOutput -match "^[AM]" -and $statusOutput.Length -gt 0)) {
        # Create commit
        Write-Host "Creating commit..." -ForegroundColor Yellow
        $commitMessage = "Initial commit: SolveIt Flutter app with Laravel backend integration"
        git commit -m $commitMessage
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   [OK] Commit created" -ForegroundColor Green
        } else {
            Write-Host "   [ERROR] Failed to create commit" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "   [INFO] No changes to commit" -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # Ensure we're on main branch
    Write-Host "Setting branch to 'main'..." -ForegroundColor Yellow
    git branch -M main 2>&1 | Out-Null
    Write-Host "   [OK] Branch set to 'main'" -ForegroundColor Green
    
    Write-Host ""
    
    # Push to GitHub
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    Write-Host "   This may prompt for GitHub credentials..." -ForegroundColor Gray
    Write-Host ""
    
    git push -u origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "   [SUCCESS] Project backed up to GitHub!" -ForegroundColor Green
        Write-Host "   Repository: $RepoUrl" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "   [ERROR] Failed to push to GitHub" -ForegroundColor Red
        Write-Host "   Common issues:" -ForegroundColor Yellow
        Write-Host "   - Authentication required (use Personal Access Token)" -ForegroundColor Gray
        Write-Host "   - Network connection issue" -ForegroundColor Gray
        Write-Host "   - Repository permissions" -ForegroundColor Gray
        Write-Host ""
        Write-Host "   Try pushing manually:" -ForegroundColor Yellow
        Write-Host "   git push -u origin main" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "No repository URL provided. Showing instructions above." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To backup now, run:" -ForegroundColor Cyan
    Write-Host "  .\backup_to_github.ps1 -RepoUrl YOUR_GITHUB_REPO_URL" -ForegroundColor White
}

Write-Host ""


