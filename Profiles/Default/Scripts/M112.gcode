(name,Tool change and Park)

; 2022-06-01	german localization
; 2022-06-06	Startbedingungen prüfen
; 2022-06-26	Code optimiert
; 2023-05-01	M999 Q1 to disable tool check added.

M999 Q1	;Startbedingungen prüfen

o<sim> if [#<_hw_sim> EQ 0]
	#<tool_loaded> = [#<_hw_input_num|#<_sx_tool_loaded_pin>> GT 0]
o<sim> else
	#<tool_loaded> = [#<_sx_sim_input_wkz_spannzange> GT 0]
o<sim> endif

o<chk> if [[#<_current_tool> EQ 0] AND [AND[#<_sx_tool_atc_occupied>,EXP2[#<pvalue> - 1]] EQ 0] AND [#<_sx_tool_loaded_pin> GT 0] AND #<tool_loaded>] 
	(dlgname,Werkzeug definieren )
	(dlg,Werkzeug wird als T#<pvalue> verwendet. Ist dies Korrekt? , typ=label, x=0, w=600, color=0xffffff)
	(dlg,./Icons/T_change.png, typ=image, x=0)
	(dlgshow)
	
	#<_current_Tool> = #<pvalue>
		
		(print,  Werkzeugversatz aktivieren)
		O<tois> if [#<_tc_tooloff_en> EQ 2]
			G43
		O<tois> elseif [#<_tc_tooloff_en> EQ 1]
			G43.1
		O<tois> endif
		
	(dlgname,Werkzeuglänge)
	(dlg,Werkzeuglänge jetzt messen?, typ=label, x=0, w=600, color=0xffffff)
	(dlg,./Icons/IMG_MeasureTool.svg, typ=image, w=256, x=0)
	(dlg,|Ja|Nein, typ=checkbox, x=50, w=410, def=0, store, param=opttool)
	(dlgshow)
	
	o<opt> if [#<opttool> EQ 1]
		G65 P122 R2 U0
	o<opt> endif
	M99
o<chk> endif


T#<pvalue> M6

M999	;Startbedingungen prüfen
M106	; Move to Machine park position

M99