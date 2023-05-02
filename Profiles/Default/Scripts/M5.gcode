; Spindel stop

M5

O<PlanetCNC> if [#<_spindle_delay_stop> GT 0]
    G04 P#<_spindle_delay_stop>
O<PlanetCNC> endif