;---------DO NOT TOUCH----------
    #SingleInstance, force
    #Persistent
    #NoEnv
    #MaxHotkeysPerInterval 10000
    #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
    ;#Warn  ; Enable warnings to assist with detecting common errors.
    SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
    SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
    ;Credit of script goes to https://stackoverflow.com/a/51464484
;---------DO NOT TOUCH----------

;---------INFORMATION----------
    ;Programmer: Projekt
    ;Date Created: 11/7/19
    ;Date Finished: 11/7/19
    /*
    Description:
        By pressing Shift+T it changes IJKL into the Arrow Keys.
        Toggle is off my default
    */
;---------INFORMATION----------


/* =======Help / Different Key Syntax=======
    FIRST THINGS FIRST:
        You need to download AutoHotKey which could be found here:
            https://www.autohotkey.com/

    HOW TO CHANGE KEY PRESS:
        -Got to "Selected keys for replacement" section and select your prefered key.
    
    HOW TO CHANGE TOGGLE KEY:
        -Go to where it says +t and change whatever you see fit. below is set of some keys that I think would
            be the most common used, if there's a key that you'd like that isn't displayed please contact me
            with one of the following methods below.
            
            KEY EXAMPLE: Alt + 5 = !5 < this means when pressing alt+5 it activates the toggle

MODIFIER KEYS:
    + = Shift(either left or right)
    ^ = Control
    ! = Alt[Default]
    <^ = left control
    >^ = Right control
    <+ = Left shift
    >+ = Right shift
    <! = Left alt
    >! = Right alt
    <# = Left windows key
    ># = Right windows key
*/

;Selected keys for replacement
Hotkey, i, Off ;i would be replaced for ArrowUp
Hotkey, j, Off
Hotkey, k, Off
Hotkey, l, Off

!t::
    Hotkey, i, Toggle
    Hotkey, j, Toggle
    Hotkey, k, Toggle
    Hotkey, l, Toggle
return
i::
    Send {Up}
return

j::
    Send {Left}
return

k::
    Send {Down}    
return

l::
    Send {Right} 
return