#SingleInstance Force
#NoEnv  
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  


	


3::				;$ prevents the hotkey from triggering itself by Send {p} below in the loop
freq:=301		;delay between key presses
	{
		{
		Send {2}	;switch
		Send {G}	;use
		Sleep %freq%	;frequence 30ms	
		Send {2}	;switch
		}
	}
return