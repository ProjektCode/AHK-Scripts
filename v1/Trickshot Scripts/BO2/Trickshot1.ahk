;Script
#SingleInstance, [force|ignore|off]
{
   ~$*XButton1:: {
   send {x up}
   send {e}
   sleep 230
   send {4 down}
   send {q}
   sleep 150
   send {q}
   sleep 50
   send {4 up}
   sleep 260
   Mouseclick, left
   sleep 50
   send {4 down}
   send {q}
   sleep 150
   send {q}
   sleep 50
   send {4 up}
   send {z up}
   sleep 260
   Mouseclick, left
   sleep 50
   send {r}

   ^1::ExitApp
}
return
}