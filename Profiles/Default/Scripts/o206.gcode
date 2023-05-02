o206 ;Request Tool Changed
; 2022-05-30	o206 created
; 2022-06-06	Texte auf Deutsch


o<check> if [#<_sx_tool_removed_num> GT 0]
	(dlgname,Werkzeug gewechselt)
	(dlg,Ist dies immer noch Werkzeug T#<_sx_tool_removed_num> ?, typ=label, x=0, w=410, color=0xffffff)
	(dlg,|Ja|Nein, typ=checkbox, x=50, w=410, def=1, store, param=opttool)
	(dlgshow)
	
	o<opt> if [#<opttool> EQ 1]
		#<_current_Tool> = #<_sx_tool_removed_num>
		
		(print,  Werkzeugversatz aktivieren)
		O<tois> if [#<_tc_tooloff_en> EQ 2]
			G43
		O<tois> elseif [#<_tc_tooloff_en> EQ 1]
			G43.1
		O<tois> endif
	o<opt> endif
o<check> endif
M99