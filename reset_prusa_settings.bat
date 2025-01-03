@echo off
setlocal EnableDelayedExpansion

:: Define menu options
set "option1=Reset PrusaSlicer Configuration File"
set "option2=Exit"

:: Main menu loop
:mainMenu
cls
echo ===== PrusaSlicer Configuration Tool =====
echo.
echo [1] %option1%
echo [2] %option2%
echo.
set /P "var=Choose an option [1-2]: "

:: Handle user choice
if "%var%"=="1" goto :reset_prusa_slicer
if "%var%"=="2" exit /b

echo [ERROR] Invalid selection. Please choose a valid option.
pause
goto mainMenu

:: Reset PrusaSlicer settings
:reset_prusa_slicer
cls
echo Starting PrusaSlicer reset process...
echo.

:: Define paths and URLs
set LOCAL_CONFIG_FILE=C:\Users\%USERNAME%\AppData\Roaming\PrusaSlicer\PrusaSlicer.ini
set BACKUP_DIR=C:\Users\%USERNAME%\AppData\Roaming\PrusaSlicer\backup
set BACKUP_CONFIG_FILE=%BACKUP_DIR%\PrusaSlicer.ini
set "GITHUB_URL=https://raw.githubusercontent.com/sam-whitley/prusa-preset/main/PrusaSlicer.ini"

:: Check if the backup file exists
if exist "%BACKUP_CONFIG_FILE%" (
    echo [INFO] Backup configuration file found.
    
    :: Compare the existing and backup files
    fc /B "%LOCAL_CONFIG_FILE%" "%BACKUP_CONFIG_FILE%" >nul
    if %errorlevel%==0 (
        echo [INFO] Local configuration file matches the backup. No changes needed.
        pause
        goto mainMenu
    ) else (
        echo [INFO] Restoring the PrusaSlicer configuration from backup...
        copy /Y "%BACKUP_CONFIG_FILE%" "%LOCAL_CONFIG_FILE%" >nul
        echo [SUCCESS] PrusaSlicer configuration restored from backup successfully!
    )
) else (
    echo [INFO] No backup configuration file found. Downloading the default configuration from GitHub...
    
    :: Create the backup directory if not present
    if not exist "%BACKUP_DIR%" (
        mkdir "%BACKUP_DIR%" >nul
        echo [SUCCESS] Backup directory created at %BACKUP_DIR%
    )
    
    :: Download the configuration file from GitHub
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%GITHUB_URL%', '%BACKUP_CONFIG_FILE%')" >nul
    
    if exist "%BACKUP_CONFIG_FILE%" (
        echo [SUCCESS] Configuration file downloaded from GitHub successfully!
    ) else (
        echo [ERROR] Failed to download the configuration file. Please check your connection and try again.
        pause
        goto mainMenu
    )
)

:: Modify the backup file only if necessary
echo [INFO] Replacing 'DefaultUser' with the current username in the configuration file...
set TEMP_FILE=%BACKUP_CONFIG_FILE%.tmp
> %TEMP_FILE% (
    for /f "tokens=* delims=" %%i in (%BACKUP_CONFIG_FILE%) do (
        set "line=%%i"
        set "line=!line:DefaultUser=%USERNAME%!"
        echo !line!
    )
)
move /Y %TEMP_FILE% %BACKUP_CONFIG_FILE%
echo [INFO] Modified backup file saved successfully.

:: Copy the modified backup to the root configuration file location
echo [INFO] Copying the updated configuration file to the root folder...
copy /Y "%BACKUP_CONFIG_FILE%" "%LOCAL_CONFIG_FILE%" >nul
echo [SUCCESS] Configuration file copied to %LOCAL_CONFIG_FILE% successfully!

pause
goto mainMenu