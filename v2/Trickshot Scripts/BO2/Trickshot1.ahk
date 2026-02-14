#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Trickshot1 Script (BO2)
; ==============================
; Description: Complex trickshot combo
;
; XButton1 (Mouse Button 4) to execute
; Ctrl+1 to exit
; ==============================

~$*XButton1:: {
    Send("{x Up}")
    Send("{e}")
    Sleep(230)
    Send("{4 Down}")
    Send("{q}")
    Sleep(150)
    Send("{q}")
    Sleep(50)
    Send("{4 Up}")
    Sleep(260)
    Click()
    Sleep(50)
    Send("{4 Down}")
    Send("{q}")
    Sleep(150)
    Send("{q}")
    Sleep(50)
    Send("{4 Up}")
    Send("{z Up}")
    Sleep(260)
    Click()
    Sleep(50)
    Send("{r}")
}

^1::ExitApp()
