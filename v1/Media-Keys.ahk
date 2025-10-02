#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
Description:
    By pressing Alt+1-6 you are able to use your media keys.
    Toggle is off by default
*/

/* =======Help / Different Key Syntax=======
    FIRST THINGS FIRST:
        You need to download AutoHotKey which could be found here:
            https://www.autohotkey.com/

    HOW TO CHANGE KEY PRESS
        -I set it to Alt by default and this works with both left and right alt.
        -To change it to a different key, I left some keys which I think would be most useful.
        -All you need to do is remove the ! that comes before the number and replace it with the wanted key.
        -If you want to change it so it uses a letter rather than a number well simply put the letter. ex) !a (This would be Alt+A)

    HOW TO CHANGE MUSIC PLAYER
        -This should be simple as to how it's layed out down below, but you need to find the saved location
            of the player you want to use.
        -I don't really know what else to say on this topic since this it's pretty simple, I couldn't get this
            to work for Groove Music player, there are scripts out there but I'm fairly new to scripting so
            at the moment I'm sort of a script kiddie meaning I grab someone else's code and modify it.
            (I still give credit were credit is due, well at least from where I got the script from.)

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

;Previous Song
!1::
Send {Media_Prev}
Return

;Next Song
!2::
Send {Media_Next}
Return

;Play / Pause
!3::
Send {Media_Play_Pause}
Return

;Volume Down
!4::
Send {Volume_Down}
Return

;Volume Up
!5::
Send {Volume_Up}
Return

;Volume Mute / Unmute
!6::
Send {Volume_Mute}
Return

;Opens Specific Player
!7::
Run "C:\Program Files (x86)\MusicBee\MusicBee.exe" ;This is the directory of your specific player.
/*
The bottom two lines can also be removed since all they do is make spotify's priority set to High and send
a message box saying what the new process's PID(Process ID) is. DO NOT remove the Return line
*/
Return