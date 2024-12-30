@echo off
setlocal enabledelayedexpansion

set GITHUB_URL=https://raw.githubusercontent.com/sam-whitley/prusa-preset/main/PrusaSlicer.ini
set CONFIG_FILE_PATH=%APPDATA%\PrusaSlicer\PrusaSlicer.ini
set HARD_CODED_HASH=fceb1d68895ac77c3f84abea7830d7ba

echo === Starting Script ===
echo Verifying the current configuration of PrusaSlicer...
echo Reference MD5 hash: %HARD_CODED_HASH%

echo Checking if PrusaSlicer.exe is currently running...
tasklist /FI "IMAGENAME eq prusa-slicer.exe" 2>NUL | find /I "prusa-slicer.exe" >NUL
if not errorlevel 1 (
    echo PrusaSlicer is currently running. Please close it before continuing.
    pause
    exit /B
)

echo PrusaSlicer is NOT running. Continuing with the script...

if exist "%CONFIG_FILE_PATH%" (
    echo The configuration file was found. Calculating its MD5 hash...
    
    :: Output file path for debugging
    echo File Path: %CONFIG_FILE_PATH%
    
    echo Checking if configuration file exists and is accessible...
    if not exist "%CONFIG_FILE_PATH%" (
        echo ERROR: Cannot access the file. Please check permissions.
        pause
        exit /B
    )
    
    :: Calculate MD5 hash
    for /f "tokens=*" %%A in ('powershell -command "(Get-FileHash -Path '%CONFIG_FILE_PATH%' -Algorithm MD5).Hash"') do set LOCAL_MD5=%%A

    if defined LOCAL_MD5 (
        echo Local MD5 Hash: !LOCAL_MD5!
    ) else (
        echo ERROR: Failed to calculate MD5 hash. Please check the file path or permissions.
        pause
        exit /B
    )
    
    :: Compare the local and hardcoded MD5 hashes
    if /I "!LOCAL_MD5!"=="%HARD_CODED_HASH%" (
        echo The configuration file is up-to-date.
    ) else (
        echo The configuration file is outdated or missing. Fetching the latest version from GitHub...
        powershell -command "(New-Object System.Net.WebClient).DownloadFile('%GITHUB_URL%', '%CONFIG_FILE_PATH%')"
        echo File successfully downloaded to: %CONFIG_FILE_PATH%
    )
) else (
    echo ERROR: Configuration file not found. Fetching the latest version from GitHub...
    powershell -command "(New-Object System.Net.WebClient).DownloadFile('%GITHUB_URL%', '%CONFIG_FILE_PATH%')"
    echo File successfully downloaded to: %CONFIG_FILE_PATH%
)

echo.
echo === Script Completed ===
pause
