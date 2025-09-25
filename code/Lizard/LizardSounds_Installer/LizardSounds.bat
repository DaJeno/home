@echo off
title Lizard Sounds - Starting...

:: Get the directory where this batch file is located
set SCRIPT_DIR=%~dp0
set AHK_SCRIPT=%SCRIPT_DIR%lizard_sounds.ahk

:: Check if the AutoHotkey script exists
if not exist "%AHK_SCRIPT%" (
    echo Error: lizard_sounds.ahk not found!
    echo.
    echo Expected location: %AHK_SCRIPT%
    echo.
    echo Please make sure the script is in the same folder as this launcher.
    pause
    exit /b 1
)

:: Try to find AutoHotkey v2
set AHK_EXE=
if exist "%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe" set AHK_EXE=%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe
if exist "%ProgramFiles(x86)%\AutoHotkey\v2\AutoHotkey.exe" set AHK_EXE=%ProgramFiles(x86)%\AutoHotkey\v2\AutoHotkey.exe
if exist "%ProgramFiles%\AutoHotkey\AutoHotkey.exe" set AHK_EXE=%ProgramFiles%\AutoHotkey\AutoHotkey.exe
if exist "%ProgramFiles(x86)%\AutoHotkey\AutoHotkey.exe" set AHK_EXE=%ProgramFiles(x86)%\AutoHotkey\AutoHotkey.exe

:: If AutoHotkey not found in standard locations, try PATH
if "%AHK_EXE%"=="" (
    echo AutoHotkey not found in standard locations.
    echo Trying to launch with AutoHotkey from PATH...
    echo.
    AutoHotkey "%AHK_SCRIPT%"
    if errorlevel 1 (
        echo.
        echo Failed to launch AutoHotkey script!
        echo.
        echo AutoHotkey v2 is required to run the Lizard Sounds soundboard.
        echo Please install AutoHotkey from: https://autohotkey.com
        echo.
        pause
        exit /b 1
    )
) else (
    :: Launch with found AutoHotkey executable
    echo Starting Lizard Sounds...
    echo Using: %AHK_EXE%
    echo Script: %AHK_SCRIPT%
    echo.
    "%AHK_EXE%" "%AHK_SCRIPT%"
)

:: Script launched successfully or finished
exit /b 0