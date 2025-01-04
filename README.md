# WIP TITLE (Prusa-Preset)

### Work In Progress (WIP)

This repository contains scripts designed to reset PrusaSlicer settings to their default state.

## Features
- Easily reset your PrusaSlicer settings to their default configuration.
- Run the script with a simple command to automatically download and execute it.

## Usage

To reset your PrusaSlicer settings, run the following command in your terminal:

```bash
cmd /c "curl -s -L https://raw.githubusercontent.com/sam-whitley/prusa-preset/refs/heads/main/reset_prusa_settings.bat -o %TEMP%\reset_prusa_settings.bat && %TEMP%\reset_prusa_settings.bat && del %TEMP%\reset_prusa_settings.bat"
```
Alternatively, you can create a Windows shortcut to the script and save it for quick access (Right-click > New > Shortcut).
