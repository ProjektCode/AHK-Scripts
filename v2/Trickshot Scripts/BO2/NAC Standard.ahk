#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; NAC Standard Script (BO2)
; ==============================
; Description: Does a decent zoom swap
; Date Created: 1/27/2020
; Author: Hiest Scripts
;
; XButton2 (Mouse Button 5) to execute
; Ctrl+1 to exit
; ==============================

XButton2:: {
    Send("{e}")
    Sleep(200)
    Send("{2}")
    Send("{4}")
    Sleep(300)
    Send("{2}")
    Sleep(260)
    Send("{RButton Down}")
    Sleep(200)
    Send("{RButton Up}")
    Click()
    Send("{1}")
    Send("{r}")
    Sleep(90)
    Send("{1}")
    Sleep(90)
    Send("{1}")
    Sleep(200)
    Click()
    Sleep(60)
    Send("{r}")
}

^1::ExitApp()
