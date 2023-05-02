(name,Tool change)

; 2022-03-04 	Measure tool if Z Offset = 0
; 2022-06-06	Startbedingungen prüfen
; 2022-06-26	Blend mit 8mm hinzugefügt

M999	;Startbedingungen prüfen

O<precheck> if [#<_tc_skipsame> AND [#<_current_tool> EQ #<_selected_tool>]]
	o<atcAutoChange> if [#<_sx_tool_atc_changeOnStopToolNum> EQ 0]
		#<_sx_tool_atc_changeOnStopToolNum> = #<_current_tool>
	o<atcAutoChange> endif
	M99
O<precheck> endif

O<precheck> if [[#<_selected_tool> LT 0] OR [#<_selected_tool> GT 10]]
	(msg,Nur T0 bis T10 sind verfügbar)
	#<_sx_canceled> = 1
	M2
O<precheck> endif

O<PlanetCNC> if [[#<_tc_toolmeasure>] AND [#<_probe_pin_1> EQ 0]]
	(msg,WKZ Längensensor ist nicht konfiguriert.)
	#<_sx_canceled> = 1
	M2
O<PlanetCNC> endif

M110 P7 Q1		;Probe disable - On Tool change it is likely that the probe is triggered due to vibration.
#<_sx_tool_temperature_suspend> = 1

M73			;Modal State Store & Autorestore
G17 G90 G91.1 G90.2 G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif
M55 P0		;Disable Transformation
M56 P0		;Disable Warp
M57 P0		;Disable Swap
M10 P1		;Motor enable
M11 P1		;Limit & Probe Enable On
G64 P6		;Blend 6mm

M102		;Flight Height
M100 Q0		;Niederhalter aus
M101 Q0		;Ölschlauch aus

#<cancel> = 0


O<en> if [ACTIVE[] AND #<_tc_enable>]
	(print,Toolchange)
	#<toisset>=0
	#<wstartx> = #<_x>
	#<wstarty> = #<_y>
	#<wstartz> = #<_z>
  
	#<spindle> = #<_spindle>
	O<sp> if [#<spindle> NE 5]
		(print,  Spindel wird ausgeschaltet)
		M5
	O<sp> endif


	O<sh> if [#<_tc_safeheight_en> AND [#<_tc_safeheight> GT #<_machine_Z>]]
		(print,  Move to safe height)
		G53 G01 Z#<_tc_safeheight> F#<_speed_traverse>
	O<sh> endif


	O<safeX> if [[#<_sx_atc_safeX> GT 0] AND [#<_machine_x> LT #<_sx_atc_safeX>] ]
		(print,  Move to safe X Position)
		G53 G01 X#<_sx_atc_safeX> F#<_speed_traverse>
	O<safeX> endif

	O<toolChangerReadyCheck> if [#<_sx_cover_open_pin> GT 0]
		M103 P#<_sx_cover_open_pin> Q1 R10.0 D0
		o<chk> if [NOTEXISTS[#<_return>]]
			(print,|!|bKeine Rückmeldung ob Abdeckung geöffnet wurde und Niederhalter in Stop position ist)
			(msg,Keine Rückmeldung ob Abdeckung geöffnet wurde und Niederhalter in Stop position ist)
			#<_sx_canceled> = 1
			M2
		o<chk> endif
	O<toolChangerReadyCheck> endif


	o<chksperrluft> if [#<_sx_sperrluft_pin_ext1> GT 0]
		#<_extout1_num|#<_sx_sperrluft_pin_ext1>> = 0
	o<chksperrluft> endif

	O<manchange> if [[[#<_tc_atc_en>] EQ 0] OR [#<_tool_skipchange_num|#<_current_tool>> NE 0]]
		(print,Manual change)
		O<po> if [#<_tc_pos_en>]
			(print,  Move to position)
			O<sh> if [#<_tc_safeheight_en>]
				G53 G01 X#<_tc_pos_x> Y#<_tc_pos_y> F#<_speed_traverse>
				G53 G01 Z#<_tc_pos_z> F#<_speed_traverse>
			O<sh> else
				G53 G01 X#<_tc_pos_x> Y#<_tc_pos_y> Z#<_tc_pos_z> F#<_speed_traverse>
			O<sh> endif
		O<po> endif

		O<ac> if [AND[#<_tc_action>, 1]]    
			O<tn> if [#<_toolchangename>]
				(dlgname,Werkzeugwechsel)
				(dlg,Werkzeug $<_toolchangename> einsetzen , typ=label, x=20, color=0xffffff)
				(dlgshow)
			O<tn> else
				(dlgname,Werkzeugwechsel)
				(dlg,Werkzeug #<_current_tool,0>: $<_current_tool> durch #<_selected_tool,0>: $<_selected_tool> ersetzen. , typ=label, x=0, w=600, color=0xffffff)
				(dlgshow)
			O<tn> endif
		O<ac> else
			O<tn> if [#<_toolchangename>]
				(print,  Change tool to $<_toolchangename>)
			O<tn> else
				(print,  Change tool #<_current_tool,0> to #<_selected_tool,0>)
			O<tn> endif
		O<ac> endif
		
		O<ac> if [AND[#<_tc_action>, 2]]
			M0
		O<ac> endif
			
	O<manchange> else
		O<atcen> if [#<_tc_atc_en>]
			(print,  ATC enabled)
			O<un> if [#<_current_tool> GT 0]
				(print,  Unload tool #<_current_tool,0>)
				O<ex> if [#<_tool_exists|#<_current_tool>> EQ 0]
					(msg,Aktuelles Werkzeug #<_current_tool,0> existiert nicht in der Werkzeugtabelle)
					#<_sx_canceled> = 1
					M2
				O<ex> endif

				O<skp> if [#<_tool_skipchange_num|#<_current_tool>> EQ 0]
					#<unposx> = #<_tool_tc_x_num|#<_current_tool>>
					#<unposy> = #<_tool_tc_y_num|#<_current_tool>>
					#<unposz> = #<_tool_tc_z_num|#<_current_tool>>
					#<unposx_in1> = [#<unposx> - #<_tc_unload_in1_x>]
					#<unposy_in1> = [#<unposy> - #<_tc_unload_in1_y>]
					#<unposz_in1> = [#<unposz> - #<_tc_unload_in1_z>]
					#<unposx_in2> = [#<unposx_in1> - #<_tc_unload_in2_x>]
					#<unposy_in2> = [#<unposy_in1> - #<_tc_unload_in2_y>]
					#<unposz_in2> = [#<unposz_in1> - #<_tc_unload_in2_z>]
       
					O<ex> if [[#<unposx> EQ 0] OR [#<unposy> EQ 0] OR [#<unposz> EQ 0]]
						(msg,Aktuelles Werkzeug #<_current_tool,0> hat keine Position im ATC)
						#<_sx_canceled> = 1
						M2
					O<ex> endif

					O<isSimulation> if [#<_hw_sim> NE 1]
						O<toolLoadCheckCancel> if [[#<_sx_tool_loaded_pin> GT 0] AND [#<_hw_input_num|#<_sx_tool_loaded_pin>> EQ 0]]
							(msg,Es ist kein Werkzeug in der Spannzange enthalten.)
							#<_sx_canceled> = 1
							M2
						O<toolLoadCheckCancel> endif
					O<isSimulation> endif

					O<occuiedCheck> if [AND[#<_sx_tool_atc_occupied>,EXP2[#<_current_tool> - 1]] NE 0]
						(dlgname,ATC Platz besetzt.)
						(dlg,Die Position T#<_current_tool> im Werkzeugwechsler ist bereits besetzt. Beim fortsetzen kann es zur Kollission kommen, typ=label, x=0, w=600, color=0xffffff)
						(dlgshow)
					O<occuiedCheck> endif
					
					
					o<chktm> if [[[#<_tool_off_z_num|#<_current_tool>> EQ 0] OR [#<_sx_tool_measureRequired> EQ 1]] AND [#<_tool_skipmeasure_num|#<_current_tool>> EQ 0] AND [#<_current_tool> GT 0]]
						(dlgname,Werkzeuglänge)
						(dlg,Werkzeuglänge wurde nicht gemessen. Jetzt messen?, typ=label, x=0, w=600, color=0xffffff)
						(dlg,|Ja|Nein, typ=checkbox, x=50, w=410, def=1, store, param=opttool)
						(dlgshow)
						o<opt> if [#<opttool> EQ 1]
							G65 P122 R2 U0
						o<opt> endif
					o<chktm> endif
					
					
					O<toolChangerReadyCheck> if [#<_sx_cover_open_pin> GT 0]
						(print,  Warte auf ATC bereitschaft #<_sx_cover_open_pin>)
						M103 P#<_sx_cover_open_pin> Q1 R10.0 D0
						o<chk> if [NOTEXISTS[#<_return>]]
							(print,Keine Rückmeldung ob Abdeckung geöffnet wurde und Niederhalter in Stop position ist)
							(msg,Keine Rückmeldung ob Abdeckung geöffnet wurde und Niederhalter in Stop position ist)
							#<_sx_canceled> = 1
							M2
						o<chk> endif
					O<toolChangerReadyCheck> endif


					O<unp11> if [[#<_tc_unload_pin1> GT 0] AND [#<_tc_unload_pin1set1> GT 0]]
						(print, _tc_unload_pin1 Schalten...)
						M62 P#<_tc_unload_pin1> Q[#<_tc_unload_pin1set1>-1]
					O<unp11> endif
					O<und11> if [#<_tc_unload_pin1delay1> GT 0]
						G04 P#<_tc_unload_pin1delay1>
					O<und11> endif


					(print,  Unload in2 position X#<unposx_in2> Y#<unposy_in2> Z#<unposz_in2>)
					O<unpos> if [#<_tc_safeheight_en>]
						G53 G01 X#<unposx_in2> Y#<unposy_in2> F#<_speed_traverse>
						G53 G01 Z#<unposz_in2> F#<_speed_traverse>
					O<unpos> else
						G53 G01 X#<unposx_in2> Y#<unposy_in2> Z#<unposz_in2> F#<_speed_traverse>
					O<unpos> endif
				  
					(print,  Unload in1 position X#<unposx_in1> Y#<unposy_in1> Z#<unposz_in1>)
					G53 G01 X#<unposx_in1> Y#<unposy_in1> Z#<unposz_in1> F#<_tc_atc_speed2>
					(print,  Unload position X#<unposx> Y#<unposy> Z#<unposz>)
					G53 G01 X#<unposx> Y#<unposy> Z#<unposz> F#<_tc_atc_speed>
					G09

					O<unp21> if [[#<_tc_unload_pin2> GT 0] AND [#<_tc_unload_pin2set1> GT 0]]
						(print, _tc_unload_pin2 Schalten...)
						M62 P#<_tc_unload_pin2> Q[#<_tc_unload_pin2set1>-1]
					O<unp21> endif
					O<und21> if [#<_tc_unload_pin2delay1> GT 0]
						G04 P#<_tc_unload_pin2delay1>
					O<und21> endif

					O<toolReleaseCheck> if [#<_sx_tool_released_pin> GT 0]
						(print,  Warte auf ablegen des werkzeugs)
						M103 P#<_sx_tool_released_pin> Q1 R2.0 D0
						o<chk> if [NOTEXISTS[#<_return>]]
							(print,Keine Rückmeldung von Spindel ob Werkzeug erforlgreich abgelegt wurde)
							(msg,Keine Rückmeldung von Spindel ob Werkzeug erforlgreich abgelegt wurde)
							#<_sx_canceled> = 1
							M2
						o<chk> endif
					O<toolReleaseCheck> endif


					#<unposx_out1> = [#<unposx> + #<_tc_unload_out1_x>]
					#<unposy_out1> = [#<unposy> + #<_tc_unload_out1_y>]
					#<unposz_out1> = [#<unposz> + #<_tc_unload_out1_z>]
					#<unposx_out2> = [#<unposx_out1> + #<_tc_unload_out2_x>]
					#<unposy_out2> = [#<unposy_out1> + #<_tc_unload_out2_y>]
					#<unposz_out2> = [#<unposz_out1> + #<_tc_unload_out2_z>]
					
					(print,  Unload out1 position X#<unposx_out1> Y#<unposy_out1> Z#<unposz_out1>)      
					G53 G01 X#<unposx_out1> Y#<unposy_out1> Z#<unposz_out1> F#<_tc_atc_speed>
					(print,  Unload out2 position X#<unposx_out2> Y#<unposy_out2> Z#<unposz_out2>)
					G53 G01 X#<unposx_out2> Y#<unposy_out2> Z#<unposz_out2> F#<_tc_atc_speed2>
					
					;Add to occupied list
					#<_sx_tool_atc_occupied> = [OR[#<_sx_tool_atc_occupied>,EXP2[#<_current_tool> - 1]]]
					
					O<unp22> if [[#<_tc_unload_pin2> GT 0] AND [#<_tc_unload_pin2set2> GT 0]]
						(print, _tc_unload_pin2 Schalten...)
						M62 P#<_tc_unload_pin2> Q[#<_tc_unload_pin2set2>-1]
					O<unp22> endif
					O<und22> if [#<_tc_unload_pin2delay2> GT 0]
						G04 P#<_tc_unload_pin2delay2>
					O<und22> endif

					;WKZ auf 0 setzen damit dies bei EStop erkannt wird
					#<_current_tool> = 0
					
					O<sh> if [#<_tc_safeheight_en>]
						(print,  Fahre auf ATC Sicherheitshöhe)
						G53 G01 Z#<_tc_safeheight> F#<_speed_traverse>
					O<sh> endif

					O<unp12> if [[#<_tc_unload_pin1> GT 0] AND [#<_tc_unload_pin1set2> GT 0]]
						(print, _tc_unload_pin1 Schalten...)
						M62 P#<_tc_unload_pin1> Q[#<_tc_unload_pin1set2>-1]
					O<unp12> endif
					O<und12> if [#<_tc_unload_pin1delay2> GT 0]
						G04 P#<_tc_unload_pin1delay2>
					O<und12> endif
				O<skp> endif
			O<un> endif


			O<ld> if [#<_selected_tool> GT 0]
				(print,  Lade Werkzeug T#<_selected_tool,0>)
				O<ex> if [#<_tool_exists|#<_selected_tool>> EQ 0]
					(msg,Werkzeug T#<_selected_tool,0> existiert nicht in der WKZ Tabelle)
					#<_sx_canceled> = 1
					M2
				O<ex> endif

				O<skp> if [#<_tool_skipchange_num|#<_selected_tool>> EQ 0]
					#<ldposx> = #<_tool_tc_x_num|#<_selected_tool>>
					#<ldposy> = #<_tool_tc_y_num|#<_selected_tool>>
					#<ldposz> = #<_tool_tc_z_num|#<_selected_tool>>
					#<ldposx_in1> = [#<ldposx> - #<_tc_load_in1_x>]
					#<ldposy_in1> = [#<ldposy> - #<_tc_load_in1_y>]
					#<ldposz_in1> = [#<ldposz> - #<_tc_load_in1_z>]
					#<ldposx_in2> = [#<ldposx_in1> - #<_tc_load_in2_x>]
					#<ldposy_in2> = [#<ldposy_in1> - #<_tc_load_in2_y>]
					#<ldposz_in2> = [#<ldposz_in1> - #<_tc_load_in2_z>]

					O<ex> if [[#<ldposx> EQ 0] OR [#<ldposy> EQ 0] OR [#<ldposz> EQ 0]]
						(msg,Ausgewähltes Werkzeug T#<_selected_tool,0> hat keine Position im ATC)
						#<_sx_canceled> = 1
						M2
					O<ex> endif
					
					O<isSimulation> if [#<_hw_sim> NE 1]		
						O<toolLoadCheckCancel> if [[#<_sx_tool_loaded_pin> GT 0] AND [#<_hw_input_num|#<_sx_tool_loaded_pin>> GT 0]]
							(msg,Es ist ein unbekanntes Werkzeug in der Spannzange enthalten.)
							#<_sx_canceled> = 1
							M2
						O<toolLoadCheckCancel> endif
					O<isSimulation> endif

					O<occuiedCheck> if [AND[#<_sx_tool_atc_occupied>,EXP2[#<_selected_tool> - 1]] EQ 0]
						(print,ATC Platz T#<_selected_tool> nicht besetzt. Es wird dennoch versucht das Werkzeug zu laden)
					O<occuiedCheck> endif

					 O<ldp11> if [[#<_tc_load_pin1> GT 0] AND [#<_tc_load_pin1set1> GT 0]]
						(print, _tc_load_pin1 Schalten...)
						M62 P#<_tc_load_pin1> Q[#<_tc_load_pin1set1>-1]
					 O<ldp11> endif
					 O<ldd11> if [#<_tc_load_pin1delay1> GT 0]
						G04 P#<_tc_load_pin1delay1>
					 O<ldd11> endif

					(print,  Load in2 position X#<ldposx_in2> Y#<ldposy_in2> Z#<ldposz_in2>)
					O<ldpos> if [#<_tc_safeheight_en>]
						G53 G01 X#<ldposx_in2> Y#<ldposy_in2> F#<_speed_traverse>
						G53 G01 Z#<ldposz_in2> F#<_speed_traverse>
					O<ldpos> else
						G53 G01 X#<ldposx_in2> Y#<ldposy_in2> Z#<ldposz_in2> F#<_speed_traverse>
					O<ldpos> endif

					O<ldp21> if [[#<_tc_load_pin2> GT 0] AND [#<_tc_load_pin2set1> GT 0]]
						(print, _tc_load_pin2 Schalten...)
						M62 P#<_tc_load_pin2> Q[#<_tc_load_pin2set1>-1]
					O<ldp21> endif
					O<ldd21> if [#<_tc_load_pin2delay1> GT 0]
						G04 P#<_tc_load_pin2delay1>
					O<ldd21> endif

					G53 G01 X#<ldposx_in1> Y#<ldposy_in1> Z#<ldposz_in1> F#<_tc_atc_speed2>
						
					O<ldp21> if [[#<_tc_load_pin2> GT 0] AND [#<_tc_load_pin2set1> GT 0]]
						G9
						(print,  Warte auf WKZ entriegelung)		
							M103 P#<_sx_tool_released_pin> Q1 R2.0 D0
							o<chk> if [NOTEXISTS[#<_return>]]
								(print,Keine Rückmeldung von Spindel ob Spannzange geöffnet wurde)
								(msg,Keine Rückmeldung von Spindel ob Spannzange geöffnet wurde)
								#<_sx_canceled> = 1
								M2
							o<chk> endif
					O<ldp21> else
						G04 P0.5
					O<ldp21> endif
						
					G53 G01 X#<ldposx> Y#<ldposy> Z#<ldposz> F#<_tc_atc_speed>
				   
					O<ldp22> if [[#<_tc_load_pin2> GT 0] AND [#<_tc_load_pin2set2> GT 0]]
						(print, _tc_load_pin2 schalten...)
						M62 P#<_tc_load_pin2> Q[#<_tc_load_pin2set2>-1]
					O<ldp22> endif
					O<ldd22> if [#<_tc_load_pin2delay2> GT 0]
						G04 P#<_tc_load_pin2delay2>
					O<ldd22> endif


					O<toolLoadCheck> if [#<_sx_tool_loaded_pin> GT 0]
						G04 P0.5
						G9
						(print,  Warte auf WKZ verriegelung)	
						M103 P#<_sx_tool_loaded_pin> Q1 R2.0 D0						;D0 bei fehler nicht abbrechen
						o<chk> if [NOTEXISTS[#<_return>]]
							(dlgname,Kein Werkzeug)
							(dlg,Es wurde kein Werkzeug gefunden. Wenn der Werkzeugplatz tatsächlich leer ist mit OK fortsetzen., typ=label, x=0, w=600, color=0xffffff)
							(dlgshow)
							#<cancel> = 1
						o<chk> endif
					O<toolLoadCheck> endif
					
					;Remove from occupied list
					#<_sx_tool_atc_occupied> = [#<_sx_tool_atc_occupied> - AND[#<_sx_tool_atc_occupied>,EXP2[#<_selected_tool> - 1]]]

					#<ldposx_out1> = [#<ldposx> + #<_tc_load_out1_x>]
					#<ldposy_out1> = [#<ldposy> + #<_tc_load_out1_y>]
					#<ldposz_out1> = [#<ldposz> + #<_tc_load_out1_z>]
					#<ldposx_out2> = [#<ldposx_out1> + #<_tc_load_out2_x>]
					#<ldposy_out2> = [#<ldposy_out1> + #<_tc_load_out2_y>]
					#<ldposz_out2> = [#<ldposz_out1> + #<_tc_load_out2_z>]
			  
					G53 G01 X#<ldposx_out1> Y#<ldposy_out1> Z#<ldposz_out1> F#<_tc_atc_speed>
					G53 G01 X#<ldposx_out2> Y#<ldposy_out2> Z#<ldposz_out2> F#<_tc_atc_speed2>
					O<sh> if [#<_tc_safeheight_en>]
						(print,  Auf sicherheitshöhe fahren) 
						G53 G01 Z#<_tc_safeheight> F#<_speed_traverse>
					O<sh> endif
				
					O<ldp12> if [[#<_tc_load_pin1> GT 0] AND [#<_tc_load_pin1set2> GT 0]]
						(print, _tc_load_pin1 Schalten...)
						M62 P#<_tc_load_pin1> Q[#<_tc_load_pin1set2>-1]
					O<ldp12> endif
					
					O<ldd12> if [#<_tc_load_pin1delay2> GT 0]
						G04 P#<_tc_load_pin1delay2>
					O<ldd12> endif
				O<skp> endif
			O<ld> endif
			
			o<iscanceled> if [#<cancel> EQ 1]
				#<_selected_tool> = 0
				#<_sx_canceled> = 1
				M2
			o<iscanceled> endif
		
			M6
			#<_sx_tool_measureRequired> = 0
		O<atcen> else
			o<iscanceled> if [#<cancel> EQ 1]
				#<_selected_tool> = 0
				#<_sx_canceled> = 1
				M2
			o<iscanceled> endif
			
			M6
			#<_sx_tool_measureRequired> = 0
		O<atcen> endif

		G09
		O<tm> if [[#<_tc_toolmeasure> GT 0] AND [#<_tool_skipmeasure_num|#<_current_tool>> EQ 0]]
			(print,  Werkzeug messen)
	  
			O<tmset> if [#<_tc_toolmeasure> EQ 2]
				G65 P122 R2 U0
				#<toisset>=2
			O<tmset> elseif [#<_tc_toolmeasure> EQ 1]
				G65 P122 R1 U0
				#<toisset>=1
			O<tmset> endif
		O<tm> endif
	
		o<chktm> if [[#<_tool_off_z_num|#<_current_tool>> EQ 0] AND [#<_tool_skipmeasure_num|#<_current_tool>> EQ 0] AND [#<_current_tool> GT 0]]
			(dlgname,Werkzeuglänge)
			(dlg,Werkzeuglänge wurde nicht gemessen. Jetzt messen?, typ=label, x=0, w=600, color=0xffffff)
			(dlgshow)
				
			G65 P122 R2 U0
		o<chktm> endif	
	O<manchange> endif


	O<toen> if [#<_tc_tooloff_en>]
		M72
		M71
		(print,  Enable tool offset)
		O<tois> if [#<_tc_tooloff_en> EQ 2]
			G43
		O<tois> elseif [#<_tc_tooloff_en> EQ 1]
			G43.1
		O<tois> endif
	O<toen> endif
  
	o<ar> if [#<_tc_autoreturn>]
		M102	;Move to flight height
		G01 X#<wstartx> Y#<wstarty> F#<_speed_traverse>
		G01 Z#<wstartz> F#<_speed_traverse>
	O<ar> endif

	o<probetool> if [#<_tool_isprobe_num|#<_selected_tool>> NE 1]
		O<sp> if [#<_tc_spindlecheck> AND [#<spindle> EQ 3]]
			(print,  Turn spindle CW)
			M3
		O<sp> elseif [#<_tc_spindlecheck> AND [#<spindle> EQ 4]]
			(print,  Turn spindle CCW)
			M4
		O<sp> endif
	o<probetool> endif
	
O<en> else
  M6
  #<_sx_tool_measureRequired> = 0
O<en> endif

o<atcAutoChange> if [#<_sx_tool_atc_changeOnStopToolNum> EQ 0]
	#<_sx_tool_atc_changeOnStopToolNum> = #<_current_tool>
o<atcAutoChange> endif

M110 P5		;Probe on of by Tool Type
#<_sx_tool_temperature_suspend> = 0

o<chksperrluft> if [#<_sx_sperrluft_pin_ext1> GT 0 AND #<_hw_isprog> EQ 1]
	#<_extout1_num|#<_sx_sperrluft_pin_ext1>> = 1
o<chksperrluft> endif