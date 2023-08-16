(name,Pause)

; 2022-02-24	stop coolant and spindle, retractZ
; 2022-02-28	add flight height check prior to retractZ
; 2022-06-05	Deutsche Texte hinzugefügt
; 2023-02-27	Option to reset optional pause. Option to show Temp dialog when pause triggered by Temperature Monitoring
; 2023-08-11	Moved Dialogs to M996 P4-P6

#<retractZ> = 0		;Retract distance on Pause 0 wegen kompatibilitätsproblemen beim fortsetzen.

;G9
M73

o<chk> if [[#<retractZ> + #<_machine_z>] GE #<_sx_machine_flightheight_z>]
	#<retractZ> = 0
o<chk> endif

o<chk> if [[#<retractZ> NE 0]]
	(print, Von Arbeitsebene abheben)
	G91 G01 Z#<retractZ>
o<chk> endif

;Check coolant state -------------
#<mist_on> = #<_mist_on>
#<flood_on> = #<_flood_on>
(print, Kühlung und Nebel aus)
M9

;Check Spindle state -------------
#<spindle_cw> = #<_spindle_cw>
#<spindle_ccw> = #<_spindle_ccw>
(print, Spindel aus)
M5

o<chksperrluft> if [#<_sx_sperrluft_pin_ext1> GT 0]
	(print, Sperrluft aus)
	#<_extout1_num|#<_sx_sperrluft_pin_ext1>> = 0
o<chksperrluft> endif


; Dialog zum fortsetzen bei zu hoher Temperatur
o<opt> if [#<_sx_tool_temperature_ok> EQ 0]
	M996 P4 ; Temperatur bearbeiten?
	o<opt2> if [#<_return> EQ 1]
		M996 P6	;Show Temperature Dialog
	o<opt2> endif
	#<_sx_tool_temperature_ok> = 1
	#<_pause_optional> = 0
o<opt> endif

; Dialog zum fortsetzen bei Pause
o<opt> if [#<_pause_optional> EQ 1]
	M996 P5	; Optionale Pause beenden?
	o<opt2> if [#<_return> EQ 1]
		#<_pause_optional> = 0
	o<opt2> endif
o<opt> endif

	

;Restore Mist and Flood state -------------
o<chksperrluft> if [#<_sx_sperrluft_pin_ext1> GT 0]
	(print, Sperrluft an)
	#<_extout1_num|#<_sx_sperrluft_pin_ext1>> = 1
o<chksperrluft> endif


o<chk> if [#<mist_on>]
	(print, Nebel an)
	M7	
o<chk> endif
o<chk> if [#<flood_on>]
	(print, Kühlung an)
	M8
o<chk> endif

;Restore Spindle state -------------
o<chk> if [#<spindle_cw>]
	(print, Spindel starten)
	M3
	G04 P2	;Zusätzliche Wartezeit wegen geringem Abstand
o<chk> endif
o<chk> if [#<spindle_ccw>]
	(print, Spindel starten)
	M4
	G04 P2	;Zusätzliche Wartezeit wegen geringem Abstand
o<chk> endif

o<chk> if [#<retractZ> NE 0]
	(print, Zurück auf Arbeitsebene)
	G91 G01 Z[#<retractZ> *-1]
o<chk> endif