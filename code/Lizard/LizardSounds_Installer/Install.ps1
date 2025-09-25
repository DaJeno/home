# Lizard Sounds Soundboard Installer (PowerShell)
# Run this script as Administrator for best results

param(
    [switch]$NoAutoHotkey,  # Skip AutoHotkey installation
    [switch]$Silent         # Silent installation
)

$Host.UI.RawUI.WindowTitle = "Lizard Sounds Installer"

function Write-Header {
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "       LIZARD SOUNDS SOUNDBOARD INSTALLER" -ForegroundColor Yellow
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param($Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Info {
    param($Message)
    Write-Host $Message -ForegroundColor White
}

function Write-Warning {
    param($Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Error {
    param($Message)
    Write-Host $Message -ForegroundColor Red
}

function Test-AutoHotkey {
    $ahkPaths = @(
        "${env:ProgramFiles}\AutoHotkey\v2\AutoHotkey.exe",
        "${env:ProgramFiles(x86)}\AutoHotkey\v2\AutoHotkey.exe",
        "${env:ProgramFiles}\AutoHotkey\AutoHotkey.exe"
    )

    foreach ($path in $ahkPaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    return $null
}

function Install-AutoHotkey {
    Write-Info "Installing AutoHotkey v2..."

    $installerPath = Join-Path $PSScriptRoot "installer\AutoHotkey_2_Setup.exe"

    if (-not (Test-Path $installerPath)) {
        Write-Error "AutoHotkey installer not found at: $installerPath"
        return $false
    }

    Write-Info "Starting AutoHotkey installer..."
    Write-Warning "Please follow the installer prompts and make sure to select AutoHotkey v2!"

    try {
        $process = Start-Process -FilePath $installerPath -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Success "AutoHotkey installed successfully!"
            return $true
        } else {
            Write-Error "AutoHotkey installation failed with exit code: $($process.ExitCode)"
            return $false
        }
    } catch {
        Write-Error "Failed to run AutoHotkey installer: $($_.Exception.Message)"
        return $false
    }
}

function Install-LizardSounds {
    # Create installation directory
    $installDir = Join-Path $env:USERPROFILE "Documents\LizardSounds"

    Write-Info "Creating installation directory: $installDir"

    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    # Copy sound files
    Write-Info "Copying sound files..."
    $soundsSource = Join-Path $PSScriptRoot "sounds"
    $soundsTarget = Join-Path $installDir "sounds"

    if (Test-Path $soundsSource) {
        Copy-Item -Path $soundsSource -Destination $soundsTarget -Recurse -Force
        Write-Success "Sound files copied successfully!"
    } else {
        Write-Error "Sound files not found at: $soundsSource"
        return $false
    }

    # Copy AutoHotkey script
    Write-Info "Copying AutoHotkey script..."
    $scriptSource = Join-Path $PSScriptRoot "lizard_sounds.ahk"
    $scriptTarget = Join-Path $installDir "lizard_sounds.ahk"

    if (Test-Path $scriptSource) {
        Copy-Item -Path $scriptSource -Destination $scriptTarget -Force
        Write-Success "AutoHotkey script copied successfully!"
    } else {
        Write-Error "AutoHotkey script not found at: $scriptSource"
        return $false
    }

    return @{
        InstallDir = $installDir
        ScriptPath = $scriptTarget
    }
}

function Create-Shortcuts {
    param($ScriptPath, $InstallDir)

    Write-Info "Creating shortcuts..."

    $WshShell = New-Object -ComObject WScript.Shell

    # Desktop shortcut
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $desktopShortcut = Join-Path $desktopPath "Lizard Sounds.lnk"

    $shortcut = $WshShell.CreateShortcut($desktopShortcut)
    $shortcut.TargetPath = $ScriptPath
    $shortcut.WorkingDirectory = $InstallDir
    $shortcut.Description = "Lizard Sounds Soundboard - Press letter keys to play sounds!"
    $shortcut.Save()

    Write-Success "Desktop shortcut created: $desktopShortcut"

    # Start menu shortcut
    $startMenuPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
    $startMenuShortcut = Join-Path $startMenuPath "Lizard Sounds.lnk"

    $shortcut = $WshShell.CreateShortcut($startMenuShortcut)
    $shortcut.TargetPath = $ScriptPath
    $shortcut.WorkingDirectory = $InstallDir
    $shortcut.Description = "Lizard Sounds Soundboard - Press letter keys to play sounds!"
    $shortcut.Save()

    Write-Success "Start menu shortcut created: $startMenuShortcut"

    return @{
        Desktop = $desktopShortcut
        StartMenu = $startMenuShortcut
    }
}

# Main installation process
try {
    Write-Header

    if (-not $Silent) {
        Write-Info "This installer will:"
        Write-Info "1. Install AutoHotkey v2 (if not already installed)"
        Write-Info "2. Set up the Lizard Sounds soundboard"
        Write-Info "3. Create desktop and start menu shortcuts"
        Write-Info ""

        $continue = Read-Host "Press Enter to continue or Ctrl+C to cancel"
    }

    # Check for AutoHotkey
    Write-Info "Checking for AutoHotkey installation..."
    $ahkPath = Test-AutoHotkey

    if ($ahkPath -and -not $NoAutoHotkey) {
        Write-Success "AutoHotkey found at: $ahkPath"
    } elseif (-not $NoAutoHotkey) {
        Write-Warning "AutoHotkey v2 not found."

        if (-not $Silent) {
            $installAhk = Read-Host "Would you like to install AutoHotkey now? (y/n)"
            if ($installAhk.ToLower() -eq 'y') {
                $installed = Install-AutoHotkey
                if (-not $installed) {
                    Write-Error "Failed to install AutoHotkey. Installation cannot continue."
                    exit 1
                }
            } else {
                Write-Warning "Skipping AutoHotkey installation. You may need to install it manually later."
            }
        } else {
            Write-Info "Silent mode: Skipping AutoHotkey installation."
        }
    }

    # Install Lizard Sounds
    Write-Info "Installing Lizard Sounds..."
    $installation = Install-LizardSounds

    if (-not $installation) {
        Write-Error "Failed to install Lizard Sounds files."
        exit 1
    }

    # Create shortcuts
    $shortcuts = Create-Shortcuts -ScriptPath $installation.ScriptPath -InstallDir $installation.InstallDir

    # Installation complete
    Write-Host ""
    Write-Header
    Write-Success "INSTALLATION COMPLETE!"
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Info "Installation location: $($installation.InstallDir)"
    Write-Info ""
    Write-Info "Desktop shortcut: $($shortcuts.Desktop)"
    Write-Info "Start menu shortcut: $($shortcuts.StartMenu)"
    Write-Host ""
    Write-Info "To use the soundboard:"
    Write-Info "1. Double-click the 'Lizard Sounds' shortcut"
    Write-Info "2. Press any letter key to play lizard sounds!"
    Write-Info "3. Press F1 for help and key mappings"
    Write-Info "4. Press Ctrl+Q to quit"
    Write-Host ""
    Write-Success "Total sounds included: 36"
    Write-Host ""

    if (-not $Silent) {
        $startNow = Read-Host "Would you like to start the Lizard Sounds soundboard now? (y/n)"
        if ($startNow.ToLower() -eq 'y') {
            Write-Info "Starting Lizard Sounds..."
            Start-Process -FilePath $installation.ScriptPath
        }
    }

    Write-Success "Thank you for installing Lizard Sounds!"

} catch {
    Write-Error "Installation failed: $($_.Exception.Message)"
    Write-Error "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}

if (-not $Silent) {
    Read-Host "Press Enter to exit"
}