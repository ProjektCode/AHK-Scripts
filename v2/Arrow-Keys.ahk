#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Arrow Keys Toggle Script
; ==============================
; Programmer: Projekt
; Date Created: 11/7/19
; Upgraded to v2: 2026
;
; Description:
;   By pressing Alt+T it changes IJKL into the Arrow Keys.
;   Toggle is off by default
;
; Modifier Keys Reference:
;   + = Shift (either left or right)
;   ^ = Control
;   ! = Alt
;   <^ = Left Control
;   >^ = Right Control
;   <+ = Left Shift
;   >+ = Right Shift
;   <! = Left Alt
;   >! = Right Alt
;   <# = Left Windows key
;   ># = Right Windows key
; ==============================

global arrowKeysEnabled := false

; Toggle hotkey (Alt+T)
!t:: {
    global arrowKeysEnabled
    arrowKeysEnabled := !arrowKeysEnabled
    ToolTip(arrowKeysEnabled ? "Arrow Keys: ON" : "Arrow Keys: OFF")
    SetTimer(() => ToolTip(), -1000)
}

; Arrow key replacements (only active when toggled on)
#HotIf arrowKeysEnabled
i::Send("{Up}")
j::Send("{Left}")
k::Send("{Down}")
l::Send("{Right}")
#HotIf
