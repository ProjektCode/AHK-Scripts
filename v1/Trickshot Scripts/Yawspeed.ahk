;Author: ShankaP
;Concept: Nunr + ShankaP
;www.youtube.com/user/ShankapotamusPC
;www.youtube.com/user/SinnerHQ
#MaxHotkeysPerInterval 10000
#SingleInstance
~NumLock::Suspend, toggle
~*F:: ;Change anything with F to desired key
 
{
SetMouseDelay -1
while GetKeyState("F")
{
    MouseMove, 3, 0, 1, R ;<--- Change MouseMove, first number to change speed.
   ; Delay(0.001)
}
Delay( D=0.001 )
{
    Static F
 
    Critical
    F ? F : DllCall( "QueryPerformanceFrequency", Int64P,F )
    DllCall( "QueryPerformanceCounter", Int64P,pTick ), cTick := pTick
    While( ( (Tick:=(pTick-cTick)/F)) < D ) {
        DllCall( "QueryPerformanceCounter", Int64P,pTick )
        Sleep -1
    }
    Return Round( Tick,3 )
}
}