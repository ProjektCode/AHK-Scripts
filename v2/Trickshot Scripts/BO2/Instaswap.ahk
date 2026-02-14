#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Instaswap Script (BO2)
; ==============================
; Description:
;   Press 3 to perform an insta-swap combo.
;   Ctrl+1 to exit.
; ==============================

3:: {
    freq := 301  ; delay between key presses
    
    Send("{2}")    ; switch
    Send("{g}")    ; use
    Sleep(freq)
    Send("{2}")    ; switch
}

^1::ExitApp()
