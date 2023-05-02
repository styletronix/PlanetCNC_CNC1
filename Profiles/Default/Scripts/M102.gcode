(name,Flight height)

; 2022-06-01	_sx_debug hinzugefügt
;Flughöhe

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

M73		;Status speichern mit Auto restore
G17 G90 G91.1 G90.2 G08 G15 G94 ;  XY Plane - XYZ Absolute - IJK Absolute - ABC Absolute - Radius - Polar Coordinate Cancel - Units per Minute


O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif
M55 P0	;Disable Transformation
M56 P0	;Disable Warp
M57 P0	;Disable Swap

O<chk> if [#<_sx_machine_flightHeight_Z> GT #<_machine_Z>]
	G53 G01 Z#<_sx_machine_flightHeight_Z> F#<_speed_traverse>
O<chk> endif