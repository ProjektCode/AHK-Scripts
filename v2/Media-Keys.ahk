#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Media Keys Script
; ==============================
; Description:
;   By pressing Alt+1-6 you are able to use your media keys.
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

; Previous Song
!1::Send("{Media_Prev}")

; Next Song
!2::Send("{Media_Next}")

; Play / Pause
!3::Send("{Media_Play_Pause}")

; Volume Down
!4::Send("{Volume_Down}")

; Volume Up
!5::Send("{Volume_Up}")

; Volume Mute / Unmute
!6::Send("{Volume_Mute}")

; Opens Specific Player (customize path as needed)
!7::Run("C:\Program Files (x86)\MusicBee\MusicBee.exe")
