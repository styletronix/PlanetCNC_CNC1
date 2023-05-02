o299	;Change Tool by MPG

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

o<chk> if [[#<_hw_mpg_custom> GE 0] AND [#<_hw_mpg_custom> LE 999]]
	M112 P#<_hw_mpg_custom>
o<chk> endif 

M99