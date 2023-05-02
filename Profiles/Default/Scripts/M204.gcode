;M204	Edit Coordinate System

; 2023-02-19 	Erste Einrichtung
; 2023-02-27	store parameter entfernt

#<cal_coordsys_x> = 0
#<cal_coordsys_y> = 0
#<cal_coordsys_z> = 0
#<cal_coordsys_rot> = 0

#<new_coordsys_x> = #<_coordsys_x>
#<new_coordsys_y> = #<_coordsys_y>
#<new_coordsys_z> = #<_coordsys_z>
#<new_coordsys_rot> = #<_coordsys_rot>
#<copyfrom_coordsys> = 0

(dlgname,Koordinatensystem bearbeiten)

(dlg,Offset bearbeiten , typ=label, x=0, w=600, color=0xffffff)
(dlg,X , x=0, dec=2, def=#<_coordsys_x>, setunits, param=new_coordsys_x)
(dlg,Y , x=0, dec=2, def=#<_coordsys_y>, setunits, param=new_coordsys_y)
(dlg,z , x=0, dec=2, def=#<_coordsys_z>, setunits, param=new_coordsys_z)
(dlg,Rot , x=0, dec=6, def=#<_coordsys_rot>, param=new_coordsys_rot)
(dlg,kopieren von , x=0, dec=0, def=0, min=0, max=9, setunits, param=copyfrom_coordsys)

(dlg,Offset justieren , typ=label, x=0, w=600, color=0xffffff)
(dlg,X , x=0, dec=2, def=0, setunits, param=cal_coordsys_x)
(dlg,Y , x=0, dec=2, def=0, setunits, param=cal_coordsys_y)
(dlg,z , x=0, dec=2, def=0, setunits, param=cal_coordsys_z)
(dlg,Rot , x=0, dec=6, def=0, param=cal_coordsys_rot)

(dlgshow)

o<opt> if [def[#<copyfrom_coordsys>,0] GT 0]
	G10 L2 P#<_coordsys> X[#<_coordsystem_x_num|#<copyfrom_coordsys>> + #<cal_coordsys_x>] Y[#<_coordsystem_y_num|#<copyfrom_coordsys>> + #<cal_coordsys_y>] Z[#<_coordsystem_z_num|#<copyfrom_coordsys>> + #<cal_coordsys_z>] R[#<_coordsystem_rot_num|#<copyfrom_coordsys>> + #<cal_coordsys_rot>]
o<opt> else
	G10 L2 P#<_coordsys> X[def[#<new_coordsys_x>,#<_coordsys_x>] + #<cal_coordsys_x>] Y[def[#<new_coordsys_y>,#<_coordsys_y>] + #<cal_coordsys_y>] Z[def[#<new_coordsys_z>,#<_coordsys_z>] + #<cal_coordsys_z>] R[def[#<new_coordsys_rot>,#<_coordsys_rot>] + #<cal_coordsys_rot>]
o<opt> endif