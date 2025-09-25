#include <windows.h>
#include <iostream>
#include <string>
#include <filesystem>

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // Get the directory where this executable is located
    char exePath[MAX_PATH];
    GetModuleFileName(NULL, exePath, MAX_PATH);

    // Extract directory path
    std::string exeDir = std::string(exePath);
    size_t lastSlash = exeDir.find_last_of("\\/");
    if (lastSlash != std::string::npos) {
        exeDir = exeDir.substr(0, lastSlash);
    }

    // Path to the AutoHotkey script
    std::string scriptPath = exeDir + "\\lizard_sounds.ahk";

    // Check if the script file exists
    if (!std::filesystem::exists(scriptPath)) {
        MessageBox(NULL,
            "Error: lizard_sounds.ahk not found!\n\n"
            "Please make sure the script is in the same folder as this executable.\n\n"
            "Expected location:\n" + std::string(scriptPath.c_str()),
            "Lizard Sounds - Script Not Found",
            MB_ICONERROR | MB_OK);
        return 1;
    }

    // Check if AutoHotkey is installed
    std::string ahkCommand;

    // Try common AutoHotkey v2 locations
    std::vector<std::string> ahkPaths = {
        "C:\\Program Files\\AutoHotkey\\v2\\AutoHotkey.exe",
        "C:\\Program Files (x86)\\AutoHotkey\\v2\\AutoHotkey.exe",
        "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe",
        "C:\\Program Files (x86)\\AutoHotkey\\AutoHotkey.exe"
    };

    bool ahkFound = false;
    for (const auto& path : ahkPaths) {
        if (std::filesystem::exists(path)) {
            ahkCommand = "\"" + path + "\" \"" + scriptPath + "\"";
            ahkFound = true;
            break;
        }
    }

    if (!ahkFound) {
        int result = MessageBox(NULL,
            "AutoHotkey not found!\n\n"
            "AutoHotkey v2 is required to run the Lizard Sounds soundboard.\n\n"
            "Would you like to:\n"
            "• YES - Try to launch anyway (if AutoHotkey is in PATH)\n"
            "• NO - Exit and install AutoHotkey first\n\n"
            "You can download AutoHotkey from: https://autohotkey.com",
            "Lizard Sounds - AutoHotkey Not Found",
            MB_ICONQUESTION | MB_YESNO);

        if (result == IDNO) {
            return 1;
        }

        // Try with just "AutoHotkey" in case it's in PATH
        ahkCommand = "AutoHotkey \"" + scriptPath + "\"";
    }

    // Launch the AutoHotkey script
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    // Convert to modifiable string for CreateProcess
    std::vector<char> cmdLine(ahkCommand.begin(), ahkCommand.end());
    cmdLine.push_back('\0');

    if (CreateProcess(NULL, cmdLine.data(), NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        // Successfully launched
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
        return 0;
    } else {
        // Failed to launch
        DWORD error = GetLastError();
        std::string errorMsg = "Failed to launch AutoHotkey script!\n\n"
                              "Command attempted: " + ahkCommand + "\n\n"
                              "Error code: " + std::to_string(error) + "\n\n"
                              "Please ensure AutoHotkey v2 is properly installed.";

        MessageBox(NULL, errorMsg.c_str(), "Lizard Sounds - Launch Failed", MB_ICONERROR | MB_OK);
        return 1;
    }
}

// Console version for debugging
int main() {
    return WinMain(GetModuleHandle(NULL), NULL, GetCommandLine(), SW_SHOW);
}