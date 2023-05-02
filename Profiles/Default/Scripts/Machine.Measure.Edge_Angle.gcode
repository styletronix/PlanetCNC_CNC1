(name,Measure Edge Angle)

; 2022-06-06	Startbedingungen prüfen

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


(dlgname,Measure Angle)
(dlg,Select start postition, typ=label, x=20, color=0xffffff)
(dlg,data::MeasureAngle, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=110, def=1, store, param=orient)
(dlg,Distance to next probe, typ=label, x=20, color=0xffffff)
(dlg,Distance, x=0, dec=2, def='setunit(20, 1)', min=0.1, max=10000, setunits, store, param=dist)
(dlgshow)

M73
G17 G90 G91.1 G90.2 G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif

M55 P0
M56 P0
M57 P0
M10 P1
M11 P1

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
  #<_sx_canceled> = 1
  M2
o<st> endif

G65 P135 H#<axis> E#<dir> D#<dist>
(print,|!Measure Edge Angle)
(print,  _measure_rot 			R#<_measure_rot>)
(print,  _measure_coordsys_rot 	R#<_measure_coordsys_rot>)
M2
