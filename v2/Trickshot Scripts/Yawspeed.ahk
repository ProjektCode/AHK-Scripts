#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Yawspeed Script
; ==============================
; Author: ShankaP
; Concept: Nunr + ShankaP
; www.youtube.com/user/ShankapotamusPC
; www.youtube.com/user/SinnerHQ
;
; Description:
;   Hold F to continuously move mouse right.
;   Press NumLock to suspend the script.
; ==============================

; NumLock to suspend script
~NumLock::Suspend(-1)

; Hold F to spin (change F to desired key)
~*F:: {
    SetMouseDelay(-1)
    while GetKeyState("F", "P") {
        MouseMove(3, 0, 0, "R")  ; Change first number to adjust speed
        HighPrecisionDelay(0.001)
    }
}

; High precision delay function
HighPrecisionDelay(seconds := 0.001) {
    static freq := 0
    if (!freq) {
        DllCall("QueryPerformanceFrequency", "Int64*", &freq)
    }
    
    DllCall("QueryPerformanceCounter", "Int64*", &startTick := 0)
    targetTick := startTick + (seconds * freq)
    
    loop {
        DllCall("QueryPerformanceCounter", "Int64*", &currentTick := 0)
        if (currentTick >= targetTick)
            break
        Sleep(-1)
    }
}
