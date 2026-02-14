#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Auto Clicker Script With Toggle
; ==============================
; Description:
;   Press F8 to toggle auto-clicking on/off
;   Press Ctrl+Alt+C to pause the script
;
; Click interval: Random 500-1500ms
; ==============================

global autoClickEnabled := false

; F8 is the key used to toggle
F8:: {
    global autoClickEnabled
    autoClickEnabled := !autoClickEnabled
    ToolTip(autoClickEnabled ? "Auto Click: ON" : "Auto Click: OFF")
    SetTimer(() => ToolTip(), -1000)
}

; Auto click timer
SetTimer(AutoClick, 100)

AutoClick() {
    global autoClickEnabled
    if (autoClickEnabled) {
        Click()
        randomDelay := Random(500, 1500)
        Sleep(randomDelay)
    }
}

; Pause script
^!c::Pause(-1)
