#include <windows.h>
#include <stdio.h>

int main() {
    char exePath[MAX_PATH];
    char ahkPath[MAX_PATH];
    char command[MAX_PATH * 2];

    // Get the directory where this exe is located
    GetModuleFileName(NULL, exePath, MAX_PATH);

    // Find the last backslash to get directory
    char* lastSlash = strrchr(exePath, '\\');
    if (lastSlash) {
        *lastSlash = '\0';  // Null terminate to get directory only
    }

    // Build path to lizard_sounds.ahk
    snprintf(ahkPath, MAX_PATH, "%s\\lizard_sounds.ahk", exePath);

    // Build command to run AutoHotkey with the script
    snprintf(command, MAX_PATH * 2, "AutoHotkey.exe \"%s\"", ahkPath);

    // Execute the command
    system(command);

    return 0;
}