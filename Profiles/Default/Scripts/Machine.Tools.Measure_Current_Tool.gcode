(name,Measure Current Tool)

M999	;Startbedingungen prüfen
M104  ;Sichere Startposition

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

G65 P122 Q#<_current_tool> R2
M2
