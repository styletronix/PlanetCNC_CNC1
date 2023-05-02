; Clean
; 2022-06-01	Pause durch Meldung ersetzt
; 2022-07-11	Meldung durch abbrechbare Meldung ersetzt
; 2022-07-13	Startbedingungen prüfen

#<niederhalterON> = [#<_hw_output_num|#<_sx_niederhalter_pin>>]
M999		;Startbedingungen prüfen
M5			;Spindel aus
M9			;Kühlung aus
M100 Q0		;Niederhalter aus
M106		;Move to Machine park position

o<dwn> if [#<niederhalterON> EQ 1]
	M100 Q1		;Niederhalter an
o<dwn> endif

(dlgname,Manuell reinigen)
(dlg,Manuell reinigen. OK setzt Programm fort, typ=label, x=20, w=410, color=0xffffff)
(dlg,./Icons/IMG_Pause.png, typ=image, x=0)
(dlgshow)

M100 Q0		;Niederhalter aus
M104		;Move to safe position