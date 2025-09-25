@echo off
setlocal
title Lizard Sounds Installer

echo ===============================================
echo       LIZARD SOUNDS SOUNDBOARD INSTALLER
echo ===============================================
echo.
echo This installer will:
echo 1. Install AutoHotkey v2 (if not already installed)
echo 2. Set up the Lizard Sounds soundboard
echo 3. Create desktop shortcuts
echo.
pause

echo.
echo Checking for AutoHotkey installation...

:: Check if AutoHotkey v2 is installed
set AHK_FOUND=0
if exist "%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe" set AHK_FOUND=1
if exist "%ProgramFiles(x86)%\AutoHotkey\v2\AutoHotkey.exe" set AHK_FOUND=1

if %AHK_FOUND%==1 (
    echo AutoHotkey v2 found! Skipping installation.
) else (
    echo AutoHotkey v2 not found. Installing...
    echo.
    echo Please follow the AutoHotkey installer prompts.
    echo Make sure to select AutoHotkey v2 when given the option.
    pause

    start /wait installer\AutoHotkey_2_Setup.exe

    echo.
    echo AutoHotkey installation complete!
    pause
)

echo.
echo Setting up Lizard Sounds...

:: Create the installation directory
set INSTALL_DIR=%USERPROFILE%\Documents\LizardSounds
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Copy files
echo Copying sound files...
xcopy /E /Y sounds "%INSTALL_DIR%\sounds\" >nul
echo Copying AutoHotkey script...
copy /Y lizard_sounds.ahk "%INSTALL_DIR%\" >nul

:: Create desktop shortcut
echo Creating desktop shortcut...
set SHORTCUT_PATH=%USERPROFILE%\Desktop\Lizard Sounds.lnk
set TARGET_PATH=%INSTALL_DIR%\lizard_sounds.ahk

:: Use PowerShell to create shortcut
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = '%TARGET_PATH%'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Lizard Sounds Soundboard'; $Shortcut.Save()"

:: Create start menu shortcut
echo Creating start menu shortcut...
set STARTMENU_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Lizard Sounds.lnk
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%STARTMENU_PATH%'); $Shortcut.TargetPath = '%TARGET_PATH%'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Lizard Sounds Soundboard'; $Shortcut.Save()"

echo.
echo ===============================================
echo           INSTALLATION COMPLETE!
echo ===============================================
echo.
echo Installation location: %INSTALL_DIR%
echo.
echo Desktop shortcut: %SHORTCUT_PATH%
echo Start menu shortcut: %STARTMENU_PATH%
echo.
echo To use the soundboard:
echo 1. Double-click the "Lizard Sounds" shortcut
echo 2. Press any letter key to play lizard sounds!
echo 3. Press F1 for help and key mappings
echo 4. Press Ctrl+Q to quit
echo.
echo Total sounds included: 36
echo.

:: Ask if user wants to start the soundboard now
set /p START_NOW="Would you like to start the Lizard Sounds soundboard now? (y/n): "
if /i "%START_NOW%"=="y" (
    echo Starting Lizard Sounds...
    start "" "%TARGET_PATH%"
)

echo.
echo Thank you for installing Lizard Sounds!
pause