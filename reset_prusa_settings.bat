@if (@CodeSection == @Batch) @then

@echo off
setlocal EnableDelayedExpansion

set "option1=Reset PrusaSlicer Settings"
set "option2=Exit"

:nextOpt
cls
echo ============================================
echo           SETTINGS RESET MENU
echo ============================================
echo.
echo 1. %option1%
echo 2. %option2%
echo.
set /P "var=Enter your choice [1-2]: "
echo.

if "%var%" equ "1" goto :reset_prusa_slicer
if "%var%" equ "2" goto :EOF

echo [WARNING] Invalid selection. Please choose a valid option.
pause
goto nextOpt

:reset_prusa_slicer
cls
echo ============================================
echo        RESETTING PRUSASLICER SETTINGS
echo ============================================
echo.

set LOCAL_CONFIG_FILE=C:\Users\%USERNAME%\AppData\Roaming\PrusaSlicer\PrusaSlicer.ini
set BACKUP_DIR=C:\Users\%USERNAME%\AppData\Roaming\PrusaSlicer\backup
set BACKUP_CONFIG_FILE=%BACKUP_DIR%\PrusaSlicer.ini
set "GITHUB_URL=https://raw.githubusercontent.com/sam-whitley/prusa-preset/main/PrusaSlicer.ini"

echo [DEBUG] LOCAL_CONFIG_FILE: %LOCAL_CONFIG_FILE%
echo [DEBUG] BACKUP_CONFIG_FILE: %BACKUP_CONFIG_FILE%
echo [DEBUG] GITHUB_URL: %GITHUB_URL%
echo.

if exist "%BACKUP_CONFIG_FILE%" (
    echo [INFO] Backup configuration file found. Copying to PrusaSlicer configuration folder...
    copy /Y "%BACKUP_CONFIG_FILE%" "%LOCAL_CONFIG_FILE%"
    echo [INFO] Backup configuration file restored successfully.
) else (
    echo [INFO] Backup configuration file not found. Attempting to download from GitHub...
    echo.

    if "%GITHUB_URL%"=="" (
        echo [ERROR] GitHub URL is empty. Please verify the URL assignment in the script.
        pause
        goto nextOpt
    )

    if not exist "%BACKUP_DIR%" (
        echo [INFO] Backup directory does not exist. Creating directory...
        mkdir "%BACKUP_DIR%"
        if %errorlevel% neq 0 (
            echo [ERROR] Failed to create the backup directory. Exiting script.
            echo.
            pause
            exit /B
        )
        echo [INFO] Backup directory created successfully at: %BACKUP_DIR%
    )

    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%GITHUB_URL%', '%BACKUP_CONFIG_FILE%')"

    if exist "%BACKUP_CONFIG_FILE%" (
        echo [INFO] Configuration file downloaded from GitHub and saved to: %BACKUP_CONFIG_FILE%
        copy /Y "%BACKUP_CONFIG_FILE%" "%LOCAL_CONFIG_FILE%"
        echo [INFO] Backup configuration file applied to PrusaSlicer successfully.
    ) else (
        echo [ERROR] Failed to download the PrusaSlicer settings file. Check your internet connection and try again.
        echo.
        pause
        goto nextOpt
    )
)

echo [INFO] PrusaSlicer settings have been successfully reset.
echo [INFO] Configuration file has been replaced with the backup or downloaded version. File path: %LOCAL_CONFIG_FILE%
echo [INFO] Settings reset process completed successfully.
echo.
pause
goto nextOpt

@end
