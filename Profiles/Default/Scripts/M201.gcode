;M201	Set CS to work position

; 2023-02-14 Q1 hinzugefügt für _hw_mpg_axisnum
; 2023-02-14 Z-Achse hinzugefügt
; 2023-02-18 Änderung von _hw_mpg_axisnum

#<axis> = DEF[#<hvalue>, #<_hw_mpg_axisnum>]


o<chk> if [[#<axis> GT 2] or [#<axis> LT 0]]	
	(msg,Achse ungültig)
	#<_sx_canceled> = 1
	M2
o<chk> endif 

	(dlgname,Nullpunkt setzen)
	(dlg,Neuen Null-Punkt auf Achse #<axis> setzen?, typ=label, x=0, w=410, color=0xffffff)

o<chk> if [#<axis> EQ 0]	
	(dlg,./Icons/IMG_OffsetX.png, typ=image, x=0)
o<chk> elseif [#<axis> EQ 1]	
	(dlg,./Icons/IMG_OffsetY.png, typ=image, x=0)
o<chk> elseif [#<axis> EQ 2]	
	(dlg,./Icons/IMG_OffsetZ.png, typ=image, x=0)
o<chk> endif 

	(dlgshow)

#<_measure> = 1
#<_return> = 1
#<_measure_x> = #<_machine_x>
#<_measure_y> = #<_machine_y>
#<_measure_z> = #<_machine_z>


o<chk> if [#<axis> EQ 2]	
	G10 L20 P#<_coordsys> Z0
o<chk> endif 

o<chk> if [[#<axis> GE 0] and [#<axis> LE 1]]
	G65 P102 H#<axis>
	$<cmd_setcsoffset>
o<chk> endif 