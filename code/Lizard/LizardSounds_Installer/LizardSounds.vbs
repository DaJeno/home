' Lizard Sounds Launcher (VBScript)
' This script launches the AutoHotkey soundboard

Option Explicit

Dim objShell, objFSO
Dim scriptDir, ahkScript, ahkExe
Dim ahkPaths, i, found

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
scriptDir = objFSO.GetParentFolderName(WScript.ScriptFullName)
ahkScript = scriptDir & "\lizard_sounds.ahk"

' Check if the AutoHotkey script exists
If Not objFSO.FileExists(ahkScript) Then
    MsgBox "Error: lizard_sounds.ahk not found!" & vbCrLf & vbCrLf & _
           "Expected location: " & ahkScript & vbCrLf & vbCrLf & _
           "Please make sure the script is in the same folder as this launcher.", _
           vbCritical, "Lizard Sounds - Script Not Found"
    WScript.Quit 1
End If

' Try to find AutoHotkey v2
ahkPaths = Array( _
    objShell.ExpandEnvironmentStrings("%ProgramFiles%") & "\AutoHotkey\v2\AutoHotkey.exe", _
    objShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\AutoHotkey\v2\AutoHotkey.exe", _
    objShell.ExpandEnvironmentStrings("%ProgramFiles%") & "\AutoHotkey\AutoHotkey.exe", _
    objShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\AutoHotkey\AutoHotkey.exe" _
)

found = False
For i = 0 To UBound(ahkPaths)
    If objFSO.FileExists(ahkPaths(i)) Then
        ahkExe = ahkPaths(i)
        found = True
        Exit For
    End If
Next

If Not found Then
    ' AutoHotkey not found in standard locations
    Dim response
    response = MsgBox("AutoHotkey not found!" & vbCrLf & vbCrLf & _
                     "AutoHotkey v2 is required to run the Lizard Sounds soundboard." & vbCrLf & vbCrLf & _
                     "Would you like to:" & vbCrLf & _
                     "• YES - Try to launch anyway (if AutoHotkey is in PATH)" & vbCrLf & _
                     "• NO - Exit and install AutoHotkey first" & vbCrLf & vbCrLf & _
                     "Download AutoHotkey from: https://autohotkey.com", _
                     vbQuestion + vbYesNo, "Lizard Sounds - AutoHotkey Not Found")

    If response = vbNo Then
        WScript.Quit 1
    End If

    ' Try with AutoHotkey from PATH
    On Error Resume Next
    objShell.Run "AutoHotkey """ & ahkScript & """", 0
    If Err.Number <> 0 Then
        MsgBox "Failed to launch AutoHotkey script!" & vbCrLf & vbCrLf & _
               "Error: " & Err.Description & vbCrLf & vbCrLf & _
               "Please install AutoHotkey v2 from: https://autohotkey.com", _
               vbCritical, "Lizard Sounds - Launch Failed"
        WScript.Quit 1
    End If
    On Error GoTo 0
Else
    ' Launch with found AutoHotkey executable
    On Error Resume Next
    objShell.Run """" & ahkExe & """ """ & ahkScript & """", 0
    If Err.Number <> 0 Then
        MsgBox "Failed to launch AutoHotkey script!" & vbCrLf & vbCrLf & _
               "AutoHotkey Path: " & ahkExe & vbCrLf & _
               "Script Path: " & ahkScript & vbCrLf & vbCrLf & _
               "Error: " & Err.Description, _
               vbCritical, "Lizard Sounds - Launch Failed"
        WScript.Quit 1
    End If
    On Error GoTo 0
End If

' Script launched successfully
WScript.Quit 0