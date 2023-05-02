M999	;Startbedingungen prüfen

#<zwert> = DEF[#<zvalue>,100]
#<step> = DEF[#<kvalue>,200]

o<chk> if[NOTEXISTS[#<xvalue>] or NOTEXISTS[#<yvalue>] or NOTEXISTS[#<ivalue>] or NOTEXISTS[#<jvalue>]]
	(msg,Parameter fehlt)
	M02
o<chk> endif

M5			;Spindel aus
M9			;Kühlung aus
M102		;Flight Height
M104		;Sichere Startposition
M100 Q0		;Niederhalter aus
M101 Q0		;Ölschlauch aus

M73		;Status speichern mit Auto restore
G17 G90 G91.1 G90.2 G08 G15 G94 ;  XY Plane - XYZ Absolute - IJK Absolute - ABC Absolute - Radius - Polar Coordinate Cancel - Units per Minute

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif
M55 P0	;Disable Transformation
M56 P0	;Disable Warp
M57 P0	;Disable Swap
G64 P50 ;Blending

#<xvalue> = 0		;X-Min
#<yvalue> = 0		;Y-Min
#<zvalue> = 100		;Z-Height
#<ivalue> = 900		;X-Max
#<jvalue> = 200		;Y-Max
#<kvalue> = 200		;Schrittweite

#<max_x1> = [MIN[[EXPR[tomachinexy(#<ivalue>,#<jvalue>,0)] + 200],#<_motorlimit_xp>]]
#<min_x1> = [MAX[EXPR[tomachinexy(#<xvalue>,#<yvalue>,0)],#<_motorlimit_xn>]]
#<min_y1> = [MAX[EXPR[tomachinexy(#<xvalue>,#<yvalue>,1)],#<_motorlimit_yn>]]
#<max_y1> = [MIN[EXPR[tomachinexy(#<ivalue>,#<jvalue>,1)],#<_motorlimit_yp>]]

#<max_x> = MAX[#<max_x1>,#<min_x1>]
#<min_x> = MIN[#<max_x1>,#<min_x1>]
#<max_y> = MAX[#<max_y1>,#<min_y1>]
#<min_y> = MIN[#<max_y1>,#<min_y1>]

#<x> = #<max_x>
#<step4> = [#<step>/4]

G53 G01 X[#<max_x>] Y[#<max_y>] F[#<_speed_traverse>]
G53 G01 Z[MIN[tomachine[#<zwert>,2],#<_motorlimit_zp>]]

G09
#<_extout1_num|#<_sx_ausblasen_pin_ext1>> = 1

o<loop> while[#<x>-#<step> GT #<min_x>]
	G53 G01 X[#<x>-#<step4>] Y#<min_y>
	G53 G01 X[#<x>-#<step4>-#<step4>] Y#<min_y>
	G53 G01 X[#<x>-#<step4>-#<step4>-#<step4>] Y#<max_y>
	G53 G01 X[#<x>-#<step>] Y#<max_y>
	#<x>  = [#<x> - #<step>]
o<loop> endwhile

G53 G01 X[#<min_x>] Y[#<min_y>]
G53 G01 X[#<min_x>] Y[#<max_y>]

G09
#<_extout1_num|#<_sx_ausblasen_pin_ext1>> = 0

M102		;Flight Height