; Move to Machine park position

; 2022-06-01	M104 durch direkten Skript ersetzt.
; 2022-06-05	Deutsche Textausgabe
; 2022-06-05	Parameter _sx_park_position_x und  _sx_park_position_y hinzugefügt
; 2022-06-06	Startbedingungen prüfen
; 2022-06-26	Blend mit 10mm hinzugefügt
; 2022-08-16	Niederhalter aus wurde entfernt

O<debug> if[#<_sx_debug> NE 0]
	(print,M106  Auf Parkpunkt fahren)
O<debug> endif

M999	;Startbedingungen prüfen

#<park_x> = [DEFNZ[#<_sx_park_position_x>,5]]
#<park_y> = [DEFNZ[#<_sx_park_position_y>,5]]

;BEGIN Set Parameters
M73
G17 G90 G91.1 G90.2 G08 G15 G94

O<debug> if [#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif

M55 P0		;Disable Transformation
M56 P0		;Disable Warp
M57 P0		;Disable Swap
G64 P10		;Blend 10mm
;END 

;M100 Q0		;Niederhalter aus

O<chk> if [[#<_sx_machine_flightHeight_Z> GT #<_machine_Z>]]
	(print,  Auf Flughöhe fahren...)
	G53 G01 Z#<_sx_machine_flightHeight_Z> F#<_speed_traverse>
O<chk> endif

O<safeX> if [[#<_sx_atc_safeX> GT 0] AND [#<_machine_x> LT #<_sx_atc_safeX>] ]
	(print,  Auf sicheren Abstand zu ATC fahren...)
    G53 G01 X#<_sx_atc_safeX> F#<_speed_traverse>
O<safeX> endif

(print,  Parkposition anfahren...)
G53 G01 X#<_sx_atc_safeX> Y#<park_y> F#<_speed_traverse>
G53 G01 X#<park_x> F#<_speed_traverse>

M110 P3		;Sonde aus