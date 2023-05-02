; Spindelstart / Stop by MPG with Warning

; 2023-02-14	Erstellt

#<ccw> = DEF[#<Qvalue>,0]

o<run> if [#<_spindle_on> EQ 0]
	(dlgname,Starte Spindel)
	(dlg,Spindel starten?, typ=label, x=0, w=600, color=0xffffff)
	(dlg,./Icons/IMG_Spindle.png, typ=image, x=0)
	(dlgshow)
	
	o<opt> if [#<ccw> EQ 0]
		M3	;CW
	o<opt> endif
	o<opt> if [#<ccw> EQ 1]
		M4	;CCW
	o<opt> endif
o<run> else
	M5	;STOP
o<run> endif
