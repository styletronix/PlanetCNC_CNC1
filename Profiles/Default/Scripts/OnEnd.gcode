; 2022-07-11	Auf Parkpunkt fahren wenn WKZ wechsel ausgewählt ist, aber WKZ nicht gewechselt wird.
; 2022-07-17	_sx_canceled hinzugefügt

O<debug> if[#<_sx_debug> NE 0]
	(print,OnEnd gcode)
O<debug> endif

M05		;Spindel aus
M09		;Kühlmittel aus

o<cancel> if [[#<_sx_machine_home_required> NE 0] OR [#<_sx_hasError> NE 0] OR [#<_sx_canceled> NE 0]]
	M02
o<cancel> endif


o<multiCS> if [#<_sx_multiCS_enabled> GT 0]
	;Reset current CS Start Request
	#<_sx_multiCS_enabled> = [#<_sx_multiCS_enabled> - AND[#<_sx_multiCS_enabled>,EXP2[#<_coordsys> -1]]]
	
	o<multiCSContinue> if [#<_sx_multiCS_enabled> GT 0]
		(print,Fahre zu Flughöhe und setze mit nächtem CS fort...)
		M102
		
		M2
	o<multiCSContinue> endif
o<multiCS> endif


o<p_check> if [#<_sx_onend_mode> EQ 1]								;Flight Height
	(print,Aktion nach Ende: Fahre zu Flughöhe)
	M102	
	
o<p_check> elseif [#<_sx_onend_mode> EQ 2]							;Maschinen Parkpunkt
	(print,Aktion nach Ende: Fahre nach Parkpunkt)
	M106	
	
o<p_check> elseif [#<_sx_onend_mode> EQ 3]							;G28 Parkpunkt
	(print,Aktion nach Ende: Fahre nach G28)
	G28
	
o<p_check> elseif [#<_sx_onend_mode> EQ 4]	
	(print,Aktion nach Ende: Wechsle Werkzeug)
	o<changeTool> if [[#<_sx_tool_atc_changeOnStopToolNum> GT 0] AND [#<_sx_tool_atc_changeOnStopToolNum> NE #<_current_tool>]]
		T#<_sx_tool_atc_changeOnStopToolNum> M06					;Tool change
	o<changeTool> else
		(print,Werkzeug bei Start nicht gefunden. Fahre zu Parkpunkt)
		M106														;Maschinen Parkpunkt
	o<changeTool> endif
o<p_check> endif