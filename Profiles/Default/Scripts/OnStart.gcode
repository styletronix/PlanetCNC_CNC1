; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen



o<chksperrluft> if [#<_sx_sperrluft_pin_ext1> GT 0]
	(print, Sperrluft an)
	#<_extout1_num|#<_sx_sperrluft_pin_ext1>> = 1
o<chksperrluft> endif


o<chktm> if [[[#<_tool_off_z_num|#<_current_tool>> EQ 0] OR [#<_sx_tool_measureRequired> EQ 1]] AND [#<_tool_skipmeasure_num|#<_current_tool>> EQ 0] AND [#<_current_tool> GT 0]]
	(dlgname,Werkzeuglänge)
	(dlg,Werkzeuglänge wurde nicht gemessen. Jetzt messen?, typ=label, x=0, w=600, color=0xffffff)
	(dlg,./Icons/IMG_MeasureTool.svg, typ=image, w=256, x=0)
	(dlg,|Ja|Nein, typ=checkbox, x=50, w=410, def=1, store, param=opttool)
	(dlgshow)
	o<opt> if [#<opttool> EQ 1]
		G65 P122 R2 U0
	o<opt> endif
o<chktm> endif


#<_sx_tool_atc_changeOnStopToolNum> = 0
M104	;Move to safe working area


o<multiCS> if [#<_sx_multiCS_enabled> GT 0]
	#<bit> = 1
	#<nextCS> = 0
	o<lp> while [EXP2[#<bit> - 1] LE #<_sx_multiCS_enabled>]
		o<chk> if [AND[#<_sx_multiCS_enabled>,EXP2[#<bit> - 1]] NE 0 ]
			o<currentCS> if [#<bit> GE #<_coordsys>]
				#<nextCS> = #<bit>
				o<lp> break
			o<currentCS> elseif [#<nextCS> EQ 0]
				#<nextCS> = #<bit>
			o<currentCS> endif		
		o<chk> endif
		#<bit> = [#<bit> + 1]
	o<lp> endwhile
	
	(print, Nächstes CS:#<nextCS>)
	G59 P#<nextCS>
o<multiCS> endif