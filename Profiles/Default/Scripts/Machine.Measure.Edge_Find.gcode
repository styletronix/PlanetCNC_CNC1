(name,Measure Edge Find)
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


(dlgname,Measure Edge Find)
(dlg,Select start postition, typ=label, x=20, color=0xffa500)
(dlg,data::MeasureAxis, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=110, def=1, store, param=orient)
(dlg,Distance, x=0, dec=2, def='setunit(10, 0.5);', min=0.1, max=10000, setunits, store, param=dist)
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

o<st> if [#<orient> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<st> elseif [#<orient> EQ 2]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<orient> EQ 3]
  #<axis> = 1
  #<dir> = +1
o<st> elseif [#<orient> EQ 4]
  #<axis> = 1
  #<dir> = -1
o<st> else
  (msg,Error)
  M2
o<st> endif

#<startz> = #<_machine_z>

G65 P131 H#<axis> E-#<dir> D#<dist>
G65 P130 H#<axis> E#<dir>
(print,|!Measure Edge Find)
G65 P102 H#<axis>

o<act> if [#<action> EQ 2]
  G53 G00 Z#<startz>
  $<cmd_moveto>
o<act> elseif [#<action> EQ 3]
  $<cmd_setworkoffset>
o<act> elseif [#<action> EQ 4]
  $<cmd_setcsoffset>
o<act> endif

M2
