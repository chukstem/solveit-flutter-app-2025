# Build APK script for SolveIt App (PowerShell version)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SolveIt App - APK Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is in PATH
$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterCmd) {
    Write-Host "ERROR: Flutter is not found in PATH!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please do one of the following:" -ForegroundColor Yellow
    Write-Host "1. Add Flutter to your system PATH" -ForegroundColor Yellow
    Write-Host "2. Or provide Flutter path below" -ForegroundColor Yellow
    Write-Host ""
    
    $flutterPath = Read-Host "Enter Flutter bin path (e.g., C:\flutter\bin)"
    
    if (-not (Test-Path "$flutterPath\flutter.bat")) {
        Write-Host "ERROR: Flutter not found at $flutterPath" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    $env:PATH = "$flutterPath;$env:PATH"
    Write-Host "Using Flutter from: $flutterPath" -ForegroundColor Green
}

Write-Host "Flutter found!" -ForegroundColor Green
Write-Host ""

# Step 1: Clean
Write-Host "Step 1: Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to clean project" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 3: Building APK (Release mode)..." -ForegroundColor Yellow
flutter build apk --release
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SUCCESS! APK built successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
Write-Host "APK Location: $apkPath" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $apkPath) {
    $apkInfo = Get-Item $apkPath
    $sizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
    Write-Host "APK Size: $sizeMB MB" -ForegroundColor Green
    Write-Host ""
    Write-Host "Opening APK location in explorer..." -ForegroundColor Yellow
    Start-Process explorer.exe -ArgumentList "/select,`"$PWD\$apkPath`""
} else {
    Write-Host "WARNING: APK file not found at expected location." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "You can now install this APK on your Android device." -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit"


