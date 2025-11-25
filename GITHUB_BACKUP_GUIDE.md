# GitHub Backup Guide for SolveIt Flutter App

This guide will help you backup your SolveIt Flutter project to GitHub.

## Prerequisites

1. **Git must be installed**
   - Download from: https://git-scm.com/download/win
   - Verify installation: Run `git --version` in PowerShell

2. **GitHub account**
   - Create account at: https://github.com
   - Get Personal Access Token (Settings > Developer settings > Personal access tokens > Tokens (classic))
     - Required scopes: `repo` (Full control of private repositories)

## Step-by-Step Backup Process

### Step 1: Create GitHub Repository

1. Go to https://github.com and sign in
2. Click the "+" icon in the top right, select "New repository"
3. Repository name: `solveit-flutter-app` (or your preferred name)
4. **Important**: Do NOT initialize with README, .gitignore, or license
5. Choose Public or Private
6. Click "Create repository"

### Step 2: Initialize Git (if not already done)

Open PowerShell in the project directory and run:

```powershell
# Check if git is initialized
git status

# If not initialized, run:
git init
```

### Step 3: Configure Git User (if not already done)

```powershell
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### Step 4: Add Remote Repository

Replace `YOUR_USERNAME` and `YOUR_REPO_NAME` with your GitHub details:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

Or if remote already exists, update it:

```powershell
git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

### Step 5: Stage All Files

```powershell
git add .
```

This will stage all files except those in `.gitignore` (which excludes sensitive files like Firebase keys, .env files, etc.)

### Step 6: Create Initial Commit

```powershell
git commit -m "Initial commit: SolveIt Flutter app with Laravel backend integration"
```

### Step 7: Push to GitHub

```powershell
git branch -M main
git push -u origin main
```

**If prompted for credentials:**
- Username: Your GitHub username
- Password: Use your Personal Access Token (NOT your GitHub password)

## Quick Backup Script

Alternatively, you can use the automated script:

```powershell
.\backup_to_github.ps1 -RepoUrl https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

## Files Excluded from Backup

The following sensitive files are automatically excluded via `.gitignore`:

- Firebase configuration files (`google-services.json`, `GoogleService-Info.plist`, `firebase.json`)
- Environment files (`.env`, `.env.*`)
- Laravel vendor directory
- Build artifacts
- Setup scripts and temporary files

## Troubleshooting

### Authentication Failed

If you get authentication errors, you need to use a Personal Access Token:

1. Go to GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Click "Generate new token (classic)"
3. Select `repo` scope
4. Copy the token
5. Use the token as your password when pushing

### Remote Already Exists

If you get "remote origin already exists" error:

```powershell
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

### Large File Upload

If files are too large (>100MB), consider using Git LFS:

```powershell
git lfs install
git lfs track "*.pdf"
git lfs track "*.mp4"
git add .gitattributes
```

### Verify Backup

After pushing, verify your backup:

1. Go to your GitHub repository page
2. Check that all files are present
3. Verify sensitive files are NOT present (should be excluded by .gitignore)

## Future Updates

To backup changes in the future:

```powershell
git add .
git commit -m "Your commit message describing changes"
git push
```

## Security Notes

⚠️ **Important**: 
- Never commit sensitive files like API keys, passwords, or private keys
- The `.gitignore` file has been configured to exclude these automatically
- Review the `.gitignore` file to ensure all sensitive files are excluded
- If you accidentally committed sensitive files, remove them immediately and change your credentials

## Need Help?

If you encounter issues:
1. Check Git installation: `git --version`
2. Check repository status: `git status`
3. Check remote configuration: `git remote -v`
4. Review error messages carefully

---

**Last Updated**: $(Get-Date -Format "yyyy-MM-dd")


