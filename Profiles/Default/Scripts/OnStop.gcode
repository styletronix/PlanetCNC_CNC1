O<debug> if[#<_sx_debug> NE 0]
	(print,OnStop gcode)
O<debug> endif

M05			;Spindel aus
M09			;Kühlmittel aus

o<chk> if [#<_sx_machine_home_required> NE 0]
	M02
o<chk> endif

o<chk> if [#<_sx_hasError> NE 0]
	M02
o<chk> endif


;M102			;Flight Height
;M101 Q0		;Ölschlauch aus
;M100 Q0		;Niederhalter aus