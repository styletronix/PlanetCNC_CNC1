(name, Probe control)

#<_return> = NAN[]
#<isProbe> = [DEF[#<qvalue>, 1]]
#<stopOnFailure> = [DEF[#<rvalue>,1]]


o<isProbe> if [#<isProbe> EQ 0]	;WKZ Sensor
	o<mode> if [#<pvalue> EQ 2]	; Check Result
		o<chk> if [#<_hw_input_num|#<_probe_pin_1>> NE 1]
			o<msgorresult> if [#<stopOnFailure> EQ 1]
				(dlgname,Störung)
				(dlg,Messung ungültig. Sensor ist nicht betätigt, typ=label, x=0, w=410, color=0xffffff)
				(dlg,./Icons/Warning.png, typ=image, x=0)
				(dlgshow)

				#<_sx_canceled> = 1
				M2
			o<msgorresult> else
				(print, Störung. Messung ungültig. Sensor ist nicht betätigt)
				#<_return> = NAN[]
				M99
			o<msgorresult> endif
		o<chk> endif
	o<mode> endif

	(print, Messung OK)
	#<_return> = 1
	M99
o<isProbe> endif



;Skip if it is not a Probing function
o<isProbe> if [#<isProbe> NE 1]
	#<_return> = 1
	M99
o<isProbe> endif


;BEGIN SUB Procedures ------------------------------------------------------------------------------------------------------------------------------------------------
o<probeon> sub
	o<requireOn> if [#<_extout1_num|#<_sx_wireless_probe_on_extout1>> EQ 0]
		(print, Funk 3D-Taster einschalten...)	
		o<chk> if [#<_sx_wireless_probe_on_extout1> GT 0]
			#<_extout1_num|#<_sx_wireless_probe_on_extout1>> = 1
			;M262 P[#<_sx_wireless_probe_on_extout1> + 100] Q1
		o<chk> endif 
		
		G04	P0.5
	o<requireOn> endif
o<probeon> endsub


o<probeoff> sub
	o<chkoff> if [#<_extout1_num|#<_sx_wireless_probe_on_extout1>> EQ 1]
		(print, Funk 3D-Taster ausschalten...)
		#<_probe_pin_2> = 0
		G9
		o<chk> if [#<_sx_wireless_probe_on_extout1> GT 0]
			#<_extout1_num|#<_sx_wireless_probe_on_extout1>> = 1
			;M262 P[#<_sx_wireless_probe_on_extout1> + 100] Q0
		o<chk> endif 
	o<chkoff> endif
o<probeoff> endsub
;END SUB Procedures ------------------------------------------------------------------------------------------------------------------------------------------------


o<opt> if [#<pvalue> EQ 5]			;Probe On Off by Tool Type
	o<probetool> if [#<_tool_isprobe_num|#<_selected_tool>> EQ 1]
		#<pvalue> = 0				;Probe on
	o<probetool> else
		#<pvalue> = 3				;Probe off
	o<probetool> endif	
	
o<opt> elseif [#<pvalue> EQ 8]		;Probe Stop On Off by Button
	o<chk> if [#<_probe_pin_2> EQ #<_sx_wireless_probe_in>]
		#<pvalue> = 7
	o<chk> else
		#<_sx_wireless_probe_lastused> = [DATETIME[]]
		#<pvalue> = 6
	o<chk> endif 	
o<opt> endif



o<chk> if [DEF[#<_sx_wireless_probe_on_extout1>,0] EQ 0]
	(msg, Keine Funk-Messonde konfiguriert)
	#<_sx_canceled> = 1
	M2
o<chk> endif

o<opt> if [#<pvalue> EQ 0]		;Probe on
	#<_sx_wireless_probe_lastused> = [DATETIME[]]
	o<probeon> call
	#<_return> = 1

o<opt> elseif [#<pvalue> EQ 1]	;Wait for Probe ready
		#<_sx_wireless_probe_lastused> = [DATETIME[]]
		o<probeon> call
		
		(print, Warte auf Funk 3D-Taster...)
		(status, Warte auf Funk 3D-Taster...)
		
		#<timeout> = [DATETIME[] + 35]
		O<loop> while [[#<_hw_input_num|#<_sx_wireless_probe_in>> NE 0] or [#<_hw_input_num|#<_sx_wireless_probe_error_in>> NE 0]]
			o<cancel> if [#<timeout> LT DATETIME[]]		
				o<msgorresult> if [#<stopOnFailure> EQ 1]
					(msg, Timeout beim warten auf Funk 3D-Taster)
					#<_sx_canceled> = 1
					M2
				o<msgorresult> else
					(print, Timeout beim warten auf Funk 3D-Taster)
					#<_return> = NAN[]
					M99
				o<msgorresult> endif			
			o<cancel> endif
			
			G04	P0.5
		O<loop> endwhile
 
	(status, )
	#<_return> = 1

o<opt> elseif [#<pvalue> EQ 2]	;Check measure result valid
	#<_sx_wireless_probe_lastused> = [DATETIME[]]
	(print, Prüfe Gültigkeit der Messung...)

	;G09 ;Controller Sync
	o<chk> if [#<_hw_input_num|#<_sx_wireless_probe_error_in>> NE 0]
		o<msgorresult> if [#<stopOnFailure> EQ 1]
			(dlgname,Funk-Störung)
			(dlg,Messung ungültig, typ=label, x=0, w=410, color=0xffffff)
			(dlg,./Icons/Warning.png, typ=image, x=0)
			(dlgshow)
			
			#<_sx_canceled> = 1
			M2
		o<msgorresult> else
			(print, Funk-Störung: Messung ungültig)	
			#<_return> = NAN[]					
			M99
		o<msgorresult> endif	
	o<chk> else
		(print, Messung OK)
		#<_return> = 1		
	o<chk> endif

o<opt> elseif [#<pvalue> EQ 3]	;Probe off
	o<probeoff> call
	#<_return> = 1

o<opt> elseif [#<pvalue> EQ 4]	;Probe On Off
	o<requireOn> if [#<_extout1_num|#<_sx_wireless_probe_on_extout1>> EQ 0]
		#<_sx_wireless_probe_lastused> = [DATETIME[]]
		o<probeon> call
		#<_return> = 1
		M99
	o<requireOn> endif	
	
	o<requireOff> if [#<_extout1_num|#<_sx_wireless_probe_on_extout1>> EQ 1]
		o<probeoff> call
		#<_return> = 1
		M99
	o<requireOff> endif	
	
	
o<opt> elseif [#<pvalue> EQ 6]	;Probe überwachen
	#<_sx_wireless_probe_lastused> = [DATETIME[]]
	(print,Sonde überwachen (Stop bei Kontakt))
	
	o<probeon> call
	
	o<wirelessProbe> if [[DEF[#<_sx_wireless_probe_in>,0] GT 0] AND [#<_probe_pin_2> NE [DEF[#<_sx_wireless_probe_in>,0]]]]
		M11P1	;Hardware Limit on
		#<_probe_pin_2> = #<_sx_wireless_probe_in>
		;G9
	o<wirelessProbe> endif
	#<_return> = 1
	
o<opt> elseif [#<pvalue> EQ 7]	;Probe nicht überwachen
	(print,Sonde nicht überwachen (Not-Halt deaktiviert))
	o<wirelessProbe> if [[DEF[#<_sx_wireless_probe_in>,0] GT 0] AND [#<_probe_pin_2> EQ [DEF[#<_sx_wireless_probe_in>,0]]]]
		#<_probe_pin_2> = 0
	o<wirelessProbe> endif
	#<_return> = 1
	
o<opt> else
	(dlgname,Fehler, opt=1)
	(dlg,Fehlerhafter P-Wert bei M110, typ=label, x=0, w=410, color=0xffffff)
	(dlg,./Icons/Warning.png, typ=image, x=0)
	(dlgshow)
	#<_sx_canceled> = 1
	M2
	
o<opt> endif
M99