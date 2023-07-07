;---------DO NOT TOUCH----------
#SingleInstance, force
#Persistent
#MaxHotkeysPerInterval 10000
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenText, On
DetectHiddenWindows, On
SetTitleMatchMode 2
SetTitleMatchMode Slow
StringCaseSense, Locale
;---------DO NOT TOUCH----------

tog:=0 ;set to 1 if you want tapfire on when script starts.
     
    ^s::tog:=!tog ;F8 hotkey to toggle tapfire on/off.
    ^a::ExitApp ;Shift F8 hotkey to exit script.
     
    #If (tog)
     
    *$LButton::
     
    While GetKeyState("LButton", "P"){
     
    Send, {E}
     
    Sleep 100 ; milliseconds
     
    }
     
    return
     
    #If