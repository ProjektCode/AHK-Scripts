;---------DO NOT TOUCH----------
#SingleInstance, force
#Persistent
#MaxHotkeysPerInterval 10000
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenText, On
DetectHiddenWindows, On
SetTitleMatchMode 2
SetTitleMatchMode Slow
StringCaseSense, Locale
;---------DO NOT TOUCH----------

$shift::
Shifted:=!Shifted
If (shifted)
  Send,{Shift Down}
else 
  Send,{Shift UP}
Return
