#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Description:
;Auto Clicker Script With Toggle
SetTimer, click, 100
Random, fg, 500, 1500

; F8 is the key used to toggle, this could be change to be a different key to be used as toggle
F8:: Toggle := !Toggle
click:
    if(Toggle)
    {
        click
        Sleep, fg
        Return
    }
Return

^!c::Pause