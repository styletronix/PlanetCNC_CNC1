; Spindelstart / Stop by MPG with Warning

; 2023-02-14	Erstellt

#<ccw> = DEF[#<Qvalue>,0]

o<run> if [#<_spindle_on> EQ 0]
	o<cancel> if [#<_tool_isprobe_num|#<_current_tool>> EQ 1]
		(dlgname,'My new dialog', bok=0, bcancel=1, w=800, h=400, bw=150, bh=40)
		(dlg, 'Spindel kann nicht bei eingesetzter Messonde eingeschaltet werden.', typ=label, x=20, w=600, color=0xfff0000)
		(dlgshow)
		M2
	o<cancel> endif 
	(dlgname,Starte Spindel)
	(dlg,Spindel starten?, typ=label, x=20, w=600, color=0xfff0000)
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
