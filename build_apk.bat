@echo off
REM Build APK script for SolveIt App
REM This script will help you build the APK

echo ========================================
echo SolveIt App - APK Builder
echo ========================================
echo.

REM Check if Flutter is in PATH
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter is not found in PATH!
    echo.
    echo Please do one of the following:
    echo 1. Add Flutter to your system PATH
    echo 2. Or provide Flutter path below
    echo.
    set /p FLUTTER_PATH="Enter Flutter path (e.g., C:\flutter\bin): "
    if not exist "%FLUTTER_PATH%\flutter.bat" (
        echo ERROR: Flutter not found at %FLUTTER_PATH%
        pause
        exit /b 1
    )
    set PATH=%FLUTTER_PATH%;%PATH%
)

echo Flutter found!
echo.

echo Step 1: Cleaning previous builds...
flutter clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to clean project
    pause
    exit /b 1
)

echo.
echo Step 2: Getting dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo Step 3: Building APK (Release mode)...
flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Build failed!
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! APK built successfully!
echo ========================================
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now install this APK on your Android device.
echo.

REM Check if APK exists
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo Opening APK location in explorer...
    start explorer "build\app\outputs\flutter-apk"
) else (
    echo WARNING: APK file not found at expected location.
)

pause


