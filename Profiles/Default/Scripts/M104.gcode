(name,Sichere Startposition)

; 2022-06-01	_sx_debug hinzugefügt
; 2022-06-05	Deutsche Textausgabe
; 2022-06-06	Startbedingungen prüfen
; 2022-06-26	Blend mit 10mm hinzugefügt

M999	;Startbedingungen prüfen

;BEGIN Parameter
M73
G17 G90 G91.1 G90.2 G08 G15 G94
O<debug> if [#<_sx_debug> EQ 0]
	M50 P0	;Disable Override Feed
O<debug> endif
M55 P0		;Disable Transformation
M56 P0		;Disable Warp
M57 P0		;Disable Swap
G64 P10		;Blend 10mm
;END

O<chk> if [[#<_sx_machine_flightHeight_Z> GT #<_machine_Z>]]
	(print, Fahre auf Flughöhe...)
	G53 G01 Z#<_sx_machine_flightHeight_Z> F#<_speed_traverse>
O<chk> endif

O<safeX> if [[#<_sx_atc_safeX> GT 0] AND [#<_machine_x> LT #<_sx_atc_safeX>] ]
	(print,  Fahre zu sicherer Startposition...)
    G53 G01 X#<_sx_atc_safeX> F#<_speed_traverse>
O<safeX> endif