@echo off
title 🦎 Lizard Sounds Soundboard

:: Hide the command window after a brief moment
if not "%1"=="hidden" (
    start /min cmd /c "%~f0" hidden
    exit
)

:: Get the directory where this batch file is located
set SCRIPT_DIR=%~dp0
set AHK_SCRIPT=%SCRIPT_DIR%lizard_sounds.ahk

:: Check if the AutoHotkey script exists
if not exist "%AHK_SCRIPT%" (
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Error: lizard_sounds.ahk not found!`n`nExpected location: %AHK_SCRIPT%`n`nPlease make sure the script is in the same folder as this launcher.', 'Lizard Sounds - Script Not Found', 'OK', 'Error')"
    exit /b 1
)

:: Try to find AutoHotkey v2
set AHK_EXE=
if exist "%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe" set AHK_EXE=%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe
if exist "%ProgramFiles(x86)%\AutoHotkey\v2\AutoHotkey.exe" set AHK_EXE=%ProgramFiles(x86)%\AutoHotkey\v2\AutoHotkey.exe
if exist "%ProgramFiles%\AutoHotkey\AutoHotkey.exe" set AHK_EXE=%ProgramFiles%\AutoHotkey\AutoHotkey.exe
if exist "%ProgramFiles(x86)%\AutoHotkey\AutoHotkey.exe" set AHK_EXE=%ProgramFiles(x86)%\AutoHotkey\AutoHotkey.exe

:: If AutoHotkey not found, show error dialog
if "%AHK_EXE%"=="" (
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('AutoHotkey not found!`n`nAutoHotkey v2 is required to run the Lizard Sounds soundboard.`n`nWould you like to try launching anyway?', 'Lizard Sounds - AutoHotkey Not Found', 'YesNo', 'Question'); if ($result -eq 'No') { exit 1 }"
    if errorlevel 1 exit /b 1

    :: Try with AutoHotkey in PATH
    AutoHotkey "%AHK_SCRIPT%" 2>nul
    if errorlevel 1 (
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Failed to launch AutoHotkey script!`n`nPlease install AutoHotkey v2 from: https://autohotkey.com', 'Lizard Sounds - Launch Failed', 'OK', 'Error')"
        exit /b 1
    )
) else (
    :: Launch with found AutoHotkey executable
    "%AHK_EXE%" "%AHK_SCRIPT%"
)

exit /b 0