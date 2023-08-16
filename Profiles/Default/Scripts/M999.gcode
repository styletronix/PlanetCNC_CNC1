; 2023-05-01	Option Q1 = skip tool check added.
; 2023-08-08	Option P1 = Display Start Dialog.

O<debug> if[#<_sx_debug> NE 0]
	(print,M999  Startbedingungen prüfen)
O<debug> endif

#<skip_ToolCheck> = DEF[#<qvalue>, 0]
#<showStartDialog> = DEF[#<pvalue>, 0]

o<chk> if [#<_sx_machine_home_required> EQ 1]
	M996 P8 ;Referenzfahrt erforderlich
	#<_sx_canceled> = 1
	M2
o<chk> endif

o<chk> if [#<_sx_hasError> NE 0]
	M996 P9 ;Störung vorhanden
	#<_sx_canceled> = 1
	M2
o<chk> endif

o<chk> if [#<_tooloff> NE 1]
	M996 P12 ;Werkzeugversatz nicht aktiv!
	#<_sx_canceled> = 1
	M2
o<chk> endif


O<isSimulation> if [[#<_hw_sim> NE 1] AND [#<skip_ToolCheck> NE 1]]	
	O<chkToolExists> if [[#<_sx_tool_loaded_pin> GT 0] AND [#<_hw_input_num|#<_sx_tool_loaded_pin>> EQ 0] AND [#<_current_tool> NE 0]]
		M996 P10 ;kein Werkzeug in Spannzange
		#<_sx_canceled> = 1
		M2
	O<chkToolExists> endif
	
	O<chkToolExists> if [[#<_sx_tool_loaded_pin> GT 0] AND [#<_hw_input_num|#<_sx_tool_loaded_pin>> EQ 1] AND [#<_current_tool> EQ 0]]
		M996 P11 ;Werkzeug in Spannzange
		#<_sx_canceled> = 1
		M2
	O<chkToolExists> endif
O<isSimulation> endif

o<chk> if [[#<showStartWarning> EQ 1] AND [#<_sx_startDialogShown> NE 1]]
	M996 P7 ;Programm starten?
	#<_sx_startDialogShown> = 1
o<chk> endif