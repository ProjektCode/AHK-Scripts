/*
DESCRIPTION: Does a decent select fire shot
DATE CREATED: 1/27/2020
AUTHOR: Hiest Scripts
*/

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

;---------SCRIPT----------
XButton1:: ;Change This to whatever you like. To know different hotkeys look in Hotkeys.txt file
{
Send, {E}
Sleep, 200
Send, {2}
Send, {4}
Sleep, 300
Send, {2}
MouseClick, Left
MouseClick, Left
MouseClick, Left
MouseClick, Left
MouseClick, Left
MouseClick, Left
MouseClick, Left
MouseClick, Left
MouseClick, Left
Send, {R}
Sleep, 250
Send, {5 Down}
Send, {5 Up}
Send, {E}
Sleep 200
Send, {1 Down}
Send, {1 Up}
Sleep 50
Send, {1 Down}
Sleep, 50
Send, {1 Up}
Sleep 80
Send {C}
Send, {1 Down}
Sleep, 70
Send, {1 Up}
Sleep, 90
MouseClick, Left
Sleep, 60
Send, {R}
}
Reload NAC Select Fire.ahk
^1::
{
ExitApp
}
;---------SCRIPT----------