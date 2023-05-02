o122 ;Measure Tool Offset

; 2022-03-07	Add check for _sx_tool_loaded_pin and option to disable return to start with U0
; 2022-06-06	Startbedingungen prüfen
; 2022-07-18	Messdistanz setzen (probeDist) 

M999	;Startbedingungen prüfen

#<_return> = NAN[]
#<num> = DEF[#<qvalue>,#<_current_tool>]
#<returnToStart> = DEF[#<uvalue>,1]
#<wkzBruchDiff> = DEF[#<vvalue>,0.1]
#<toolmeasure> = DEF[#<rvalue>,#<_tc_toolmeasure>]

o<skp> if [#<_tool_skipmeasure_num|#<num>> GT 0]
  (print,Messung für T#<num> übersprungen)
  M99
o<skp> endif

G9
O<isSimulation> if [#<_hw_sim> NE 1]	
	O<chkToolExists> if [[#<_sx_tool_loaded_pin> GT 0] AND [#<_hw_input_num|#<_sx_tool_loaded_pin>> EQ 0]]
		(print,Es ist kein Werkzeug in der Spannzange enthalten.)
		(msg,Es ist kein Werkzeug in der Spannzange enthalten.)
		#<_sx_canceled> = 1
		M2
	O<chkToolExists> endif
O<isSimulation> endif

G65 P109 Q0

o<chk> if [NOTEXISTS[#<_return>]]
  (msg,Fehler beim prüfen der Sonde für WKZ Offset)
  #<_sx_canceled> = 1
  M2
o<chk> endif

M102		;Flight Height
M100 Q0		;Niederhalter aus
M101 Q0		;Ölschlauch aus
M104		;Safe start position

M73
G08 G15 G90 G91.1 G90.2 G94

O<debug> if [#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif

M55 P0
M56 P0
M57 P0
M10 P1

#<startX> = #<_machine_x>
#<startY> = #<_machine_y>

#<sox> = [DEF[#<_tool_so_x_num|#<_current_tool>>,0]]
#<soy> = [DEF[#<_tool_so_y_num|#<_current_tool>>,0]]
#<soz> = [DEF[#<_tool_so_z_num|#<_current_tool>>,0]]

G53 G00 Z#<_tooloff_safeheight>
G53 G00 Y[#<_tooloff_sensory> - #<soy>]
G53 G00 X[#<_tooloff_sensorx> - #<sox>]
G53 G00 Z#<_tooloff_rapidheight>

#<probeDist> = [#<_tooloff_rapidheight> - #<_tooloff_sensorz> - 20]

O<isSimulation> if [[#<_hw_sim> EQ 1] and [#<toolmeasure> EQ 3]]
	(print, Simulation: WKZ Bruchkontrolle wird nicht durchgeführt!)
	G53 G01 Z[#<_tooloff_z> + #<_tooloff_sensorz>]  F#<_tooloff_speed>
	#<_return> = #<_tool_off_z_num|#<num>>
	#<_measure> = #<_tool_off_z_num|#<num>>
	#<_measure_z> = #<_tool_off_z_num|#<num>>
	
O<isSimulation> else
	(print, WKZ Länge messen)
	G65 P110 H2 E-1 Q0 R1 D#<probeDist> K#<_tooloff_swdist> J[#<_tooloff_sensorz> + #<soz>] F#<_tooloff_speed> I#<_tooloff_speed_low>

O<isSimulation> endif

G53 G00 Z#<_tooloff_safeheight>



o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Fehler beim messen der Werkzeuglänge)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<off> = #<_measure_z>
o<chk> if[#<toolmeasure> EQ 1]
  M72
  M71
  G43.1 Z#<off>
  
o<chk> elseif[#<toolmeasure> EQ 2]
  G10 L1 P#<num> Z#<off>
  
o<chk> elseif[#<toolmeasure> EQ 3]
	o<diff> if [[#<_tool_off_z_num|#<num>> GT [#<off> + #<wkzBruchDiff>]] OR [#<_tool_off_z_num|#<num>> LT [#<off> - #<wkzBruchDiff>]]]
		  (print,WKZ Bruchkontrolle fehlerhaft.)
		  (print,Erwartet #<_tool_off_z_num|#<num>> IST #<off>)
		  (msg,WKZ Bruchkontrolle fehlerhaft.)
		  #<_sx_canceled> = 1
		  M2
	o<diff> else
		(print,WKZ Bruchkontrolle OK.)
		(print,Erwartet #<_tool_off_z_num|#<num>> IST #<off>)
	o<diff> endif
o<chk> endif

M102	;Flight Height
M104	;Safe start position
o<chk> if [#<returnToStart> GT 0]
	G53 G00 X#<startX> Y#<startY>
o<chk> endif

#<_return> = #<off>
#<_sx_tool_measureRequired> = 0

M99
