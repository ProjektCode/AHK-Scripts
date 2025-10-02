/*
DESCRIPTION: Does a decent zoom swap
DATE CREATED: 1/27/2020
AUTHOR: Hiest Scripts
*/

;---------DO NOT TOUCH----------
#SingleInstance, force
#Persistent
#NoEnv
#MaxHotkeysPerInterval 10000
;---------DO NOT TOUCH----------

;---------SCRIPT----------
XButton2::
Send, {E}
Sleep, 200
Send, {2}
Send, {4}
Sleep, 300
Send, {2}
Sleep, 260
SendInput, {RButton Down}
Sleep, 200
SendInput, {RButton Up}
MouseClick, Left
Send, {1}
Send, {R}
Sleep, 90
Send, {1}
Sleep, 90
Send, {1}
Sleep, 200
MouseClick, Left
Sleep, 60
Send, {R}

^1::
{
ExitApp
}

Reload NAC Standard.ahk
;---------SCRIPT----------