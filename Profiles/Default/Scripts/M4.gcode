; Spindelstart CCW

M4

O<PlanetCNC> if [#<_spindle_delay_start> GT 0]
    G04 P#<_spindle_delay_start>
O<PlanetCNC> endif