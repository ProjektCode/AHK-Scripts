#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; NAC Select Fire Script (BO2)
; ==============================
; Description: Does a decent select fire shot
; Date Created: 1/27/2020
; Author: Hiest Scripts
;
; XButton1 (Mouse Button 4) to execute
; Ctrl+1 to exit
; ==============================

XButton1:: {
    Send("{e}")
    Sleep(200)
    Send("{2}")
    Send("{4}")
    Sleep(300)
    Send("{2}")
    
    ; Multiple clicks for select fire
    Loop 9 {
        Click()
    }
    
    Send("{r}")
    Sleep(250)
    Send("{5 Down}")
    Send("{5 Up}")
    Send("{e}")
    Sleep(200)
    Send("{1 Down}")
    Send("{1 Up}")
    Sleep(50)
    Send("{1 Down}")
    Sleep(50)
    Send("{1 Up}")
    Sleep(80)
    Send("{c}")
    Send("{1 Down}")
    Sleep(70)
    Send("{1 Up}")
    Sleep(90)
    Click()
    Sleep(60)
    Send("{r}")
}

^1::ExitApp()
