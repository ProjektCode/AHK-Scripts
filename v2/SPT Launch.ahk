; ==============================
; SPT Launch (AHK v2)
; Hotkey: Ctrl + Shift + S
; Launches the SPT Mod for EFT
; ==============================

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

;----Run SPT Server----
Run A_ScriptDir "\SPT.Server.exe"
Sleep 30000
;----Run SPT Launcher----
Run A_ScriptDir "\SPT.Launcher.exe"

ExitApp