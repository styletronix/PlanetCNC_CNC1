(name,Measure Hole)
M999	;Startbedingungen prüfen

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  #<_sx_canceled> = 1
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  #<_sx_canceled> = 1
  M2
o<chk> endif


(dlgname,Measure Hole)
(dlg,data::MeasureHole, typ=image, x=75)
(dlg,Action|Nothing|Move|\Set WO|Set CS, typ=checkbox, x=20, w=90, def=1, store, param=action)
(dlgshow)

M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1

G65 P150

o<act> if [#<action> EQ 2]
  $<cmd_moveto>
o<act> elseif [#<action> EQ 3]
  $<cmd_setworkoffset>
o<act> elseif [#<action> EQ 4]
  $<cmd_setcsoffset>
o<act> endif

M2
