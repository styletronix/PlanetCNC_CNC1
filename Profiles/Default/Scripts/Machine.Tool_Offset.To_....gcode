M997  ;Abbruch
O<PlanetCNC> if[#<_coord_x_en> GT 0]
  G43.1 X#<_coord_x>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_y_en> GT 0]
  G43.1 Y#<_coord_y>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_z_en> GT 0]
  G43.1 Z#<_coord_z>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_a_en> GT 0]
  G43.1 A#<_coord_a>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_b_en> GT 0]
  G43.1 B#<_coord_b>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_c_en> GT 0]
  G43.1 C#<_coord_c>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_u_en> GT 0]
  G43.1 U#<_coord_u>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_v_en> GT 0]
  G43.1 V#<_coord_v>
O<PlanetCNC> endif
O<PlanetCNC> if[#<_coord_w_en> GT 0]
  G43.1 W#<_coord_w>
O<PlanetCNC> endif
