;M202	Auswahl Bearbeitungsbereich

; 2023-02-14 Erste Einrichtung

#<_sx_cycle_area_x_start> = DEF[#<avalue>, #<_sx_cycle_area_x_start>]
#<_sx_cycle_area_y_start> = DEF[#<bvalue>, #<_sx_cycle_area_y_start>]
#<_sx_cycle_area_pattern_start> = DEF[#<cvalue>, #<_sx_cycle_area_pattern_start>]
#<_sx_cycle_area_cycle_start> = DEF[#<dvalue>, #<_sx_cycle_area_cycle_start>]

#<_sx_cycle_area_x_end> = DEF[#<qvalue>, #<_sx_cycle_area_x_end>]
#<_sx_cycle_area_y_end> = DEF[#<rvalue>, #<_sx_cycle_area_y_end>]
#<_sx_cycle_area_pattern_end> = DEF[#<uvalue>, #<_sx_cycle_area_pattern_end>]
#<_sx_cycle_area_cycle_end> = DEF[#<vvalue>, #<_sx_cycle_area_cycle_end>]


	(dlgname,Bearbeitungsbereich)
	(dlg,Bearbeitungsbereich angeben, typ=label, x=0, w=600, color=0xffffff)
	
	(dlg,Start:, typ=label, x=0, w=600, color=0xffffff)
	(dlg,X, x=50, dec=0, def=_sx_cycle_area_x_start, param=_sx_cycle_area_x_start)
	(dlg,Y, x=50, dec=0, def=_sx_cycle_area_y_start, param=_sx_cycle_area_y_start)
	(dlg,Pattern, x=50, dec=0, def=_sx_cycle_area_pattern_start, param=_sx_cycle_area_pattern_start)
	(dlg,Cycle, x=50, dec=0, def=_sx_cycle_area_cycle_start, param=_sx_cycle_area_cycle_start)

	(dlg,Ende:, typ=label, x=0, w=600, color=0xffffff)
	(dlg,X, x=50, dec=0, def=_sx_cycle_area_x_end, param=_sx_cycle_area_x_end)
	(dlg,Y, x=50, dec=0, def=_sx_cycle_area_y_end, param=_sx_cycle_area_y_end)
	(dlg,Pattern, x=50, dec=0, def=_sx_cycle_area_pattern_end, param=_sx_cycle_area_pattern_end)
	(dlg,Cycle, x=50, dec=0, def=_sx_cycle_area_cycle_end, param=_sx_cycle_area_cycle_end)

	(dlgshow)
	