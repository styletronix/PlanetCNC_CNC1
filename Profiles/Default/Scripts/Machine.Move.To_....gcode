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
O<PlanetCNC> if[#<_coord_x_en> GT 0]
  #<x> = #<_coord_x>
O<PlanetCNC> else
  #<x> = #<_x>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_y_en> GT 0]
  #<y> = #<_coord_y>
O<PlanetCNC> else
  #<y> = #<_y>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_z_en> GT 0]
  #<z> = #<_coord_z>
O<PlanetCNC> else
  #<z> = #<_z>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_a_en> GT 0]
  #<a> = #<_coord_a>
O<PlanetCNC> else
  #<a> = #<_a>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_b_en> GT 0]
  #<b> = #<_coord_b>
O<PlanetCNC> else
  #<b> = #<_b>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_c_en> GT 0]
  #<c> = #<_coord_c>
O<PlanetCNC> else
  #<c> = #<_c>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_u_en> GT 0]
  #<u> = #<_coord_u>
O<PlanetCNC> else
  #<u> = #<_u>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_v_en> GT 0]
  #<v> = #<_coord_v>
O<PlanetCNC> else
  #<v> = #<_v>
O<PlanetCNC> endif

O<PlanetCNC> if[#<_coord_w_en> GT 0]
  #<w> = #<_coord_w>
O<PlanetCNC> else
  #<w> = #<_w>
O<PlanetCNC> endif

G00 X#<x> Y#<y> Z#<z> A#<a> B#<b> C#<c> U#<u> V#<v> W#<w>
