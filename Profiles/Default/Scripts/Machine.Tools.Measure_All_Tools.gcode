M997  ;Abbruch
M999	;Startbedingungen prüfen
M104  ;Sichere Startposition

(name,Measure All Tools)
o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  #<_sx_canceled> = 1
  M2
o<chk> endif

M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1
o<loop> do
  G53 G00 Z#<_tooloff_safeheight>

  (dlgname)
  (dlg, Tool Number, x=20, dec=0, def=0, min=1, max=999, store, param=num)
  (dlgshow)
  o<skp> if [#<_tool_skipmeasure_num|#<num>> GT 0]
    (msg,Measuring skipped)
  o<skp> else
    G65 P122 Q#<num> R2
  o<skp> endif
  #<num> = [#<num>+1]
o<loop> while[#<num> LT 1000]
M2
