(name,Measure Outside Corner)
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

(dlgname,Measure Outside Corner)
(dlg,Select corner, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureCornerOutside, typ=image, x=0)
(dlg,|X+Y+|X+Y-|X-Y-|X-Y+, typ=checkbox, x=50, w=110, def=1, store, param=corner)
(dlg,Distance from X edge, typ=label, x=20, w=455, color=0xffa500)
(dlg,Edge, x=0, dec=2, def='setunit(10, 0.5);', min=0.1, max=10000, setunits, store, param=edge)
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

o<st> if [#<corner> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<st> elseif [#<corner> EQ 2]
  #<axis> = 1
  #<dir> = -1
o<st> elseif [#<corner> EQ 3]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<corner> EQ 4]
  #<axis> = 1
  #<dir> = +1
o<st> else
  (msg,Error)
  #<_sx_canceled> = 1
  M2
o<st> endif

#<startz> = #<_machine_z>

G65 P145 H#<axis> E#<dir> D#<edge>

o<act> if [#<action> EQ 2]
  G53 G00 Z#<startz>
  $<cmd_moveto>
o<act> elseif [#<action> EQ 3]
  $<cmd_setworkoffset>
o<act> elseif [#<action> EQ 4]
  $<cmd_setcsoffset>
o<act> endif

M2
