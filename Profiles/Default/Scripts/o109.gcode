o109 ;Probe Check

; 2023-08-02 Prüft ob WKZ Längensensor bereits gedrückt ist oder Endschalter aktiv.


#<_return> = NAN[]
#<isProbe> = [DEF[#<qvalue>,1]]

o<chk> if[LNOT[ACTIVE[]]]
	M99
o<chk> endif

;Check if limit switch is active.
G09
o<cklimit> if [#<_hw_limit> NE 0]
	(msg,Ein Endschalter ist aktiv. Messung nicht möglich.)
	#<_sx_canceled> = 1
	M2
o<cklimit> endif

o<qmode> if [#<isProbe>]  ;Is Probe
	o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
		(msg,Aktuelles Werkzeug ist keine Sonde)
		#<_sx_canceled> = 1
		M2
	o<chk> endif

	M110 P0		;Probe on
	M110 P1		;Wait for Probe ready
	M110 P6		;Use Probe

	;Additional check to make sure _probe_pin_2 is not 0
	o<chk> if[[#<_probe_pin_2> EQ 0]]
		(msg,Eingang 2 für Sonde ist nicht konfiguriert)
		#<_sx_canceled> = 1
		M2
	o<chk> endif

o<qmode> else                 ;Werkzeuglänge
	;Additional check to make sure _probe_pin_1 is not 0
    o<chk> if[[#<_probe_pin_1> EQ 0]]
		(msg,Eingang 1 für Werkzeugtaster ist nicht konfiguriert)
		#<_sx_canceled> = 1
		M2
    o<chk> endif

	O<chkToolExists> if [[#<_hw_sim> NE 1]	AND [#<_sx_tool_loaded_pin> GT 0] AND [#<_hw_input_num|#<_sx_tool_loaded_pin>> EQ 0]]
		(msg,Es ist kein Werkzeug in der Spannzange enthalten.)
		#<_sx_canceled> = 1
		M2
	O<chkToolExists> endif

	; Check if Sensor is already triggered
	M103 P#<_probe_pin_1> Q0 R2.0 
o<qmode> endif

#<_return> = 1
M99