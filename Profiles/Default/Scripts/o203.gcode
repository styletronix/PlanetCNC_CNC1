o203; Set Z Limit by Tool offset
; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

o<chk> if  [DEF[#<_sx_limit_z_byTool>,0] EQ 0]
	M99
o<chk> endif

#<_motorlimit_zn> = MIN[[#<_motorlimit_zp> -1] ,[MAX[#<_sx_limit_z_min>, [#<_sx_limit_z_min> + #<_sx_limit_z_byTool> + #<_tooloff_z> ]]]]
M99