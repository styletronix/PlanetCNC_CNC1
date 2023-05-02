o298	;Change CoordSystem by MPG

o<chk> if [[#<_hw_mpg_custom> GE 1] AND [#<_hw_mpg_custom> LE 1000]]
	#<_coordsys> = #<_hw_mpg_custom>
o<chk> endif 

M99