#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Toggle Shift Script
; ==============================
; Description:
;   Press Shift to toggle Shift being held down.
;   Useful for games or applications that require
;   holding shift for extended periods.
; ==============================

global shiftToggled := false

$Shift:: {
    global shiftToggled
    shiftToggled := !shiftToggled
    if (shiftToggled) {
        Send("{Shift Down}")
        ToolTip("Shift: HELD")
    } else {
        Send("{Shift Up}")
        ToolTip("Shift: Released")
    }
    SetTimer(() => ToolTip(), -1000)
}
