M997  ;Abbruch
M999	;Startbedingungen prüfen
M104  ;Sichere Startposition

M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1
O<PlanetCNC> if[#<_mark> GT 0]
  G53 G00 X#<_mark_x> Y#<_mark_y> Z#<_mark_z> A#<_mark_a> B#<_mark_b> C#<_mark_c> U#<_mark_u> V#<_mark_v> W#<_mark_w>
O<PlanetCNC> endif
