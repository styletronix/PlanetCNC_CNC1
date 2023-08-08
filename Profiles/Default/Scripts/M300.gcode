; Spindelstart / Stop by MPG with Warning

; 2023-02-14	Erstellt

#<ccw> = DEF[#<Qvalue>,0]

o<run> if [#<_spindle_on> EQ 0]
	o<cancel> if [#<_tool_isprobe_num|#<_current_tool>> EQ 1]
		M996 P1
		#<_sx_canceled> = 1
		M2
	o<cancel> endif 
	M996 P2
	
	o<opt> if [#<ccw> EQ 0]
		M3	;CW
	o<opt> endif
	o<opt> if [#<ccw> EQ 1]
		M4	;CCW
	o<opt> endif
o<run> else
	M5	;STOP
o<run> endif
