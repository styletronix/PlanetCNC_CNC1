(name,Measure Surface Angle)
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


(dlgname,Measure Surface Angle)
(dlg,data::MeasureSurfaceAngle, typ=image, x=55)
(dlg,Distance, typ=label, x=20, color=0xffa500)
(dlg,, x=50, dec='setunit(1,2);', def='setunit(40,1.5);', min='setunit(1,0.1);', max=10000, setunits, store, param=dist)
(dlg,|3 point|5 point, typ=checkbox, x=20, w=90, def=2, store, param=option)
(dlgshow)

o<chk> if[#<option> EQ 1]
  G65 P191 D#<dist>
o<chk> elseif[#<option> EQ 2]
  G65 P192 D#<dist>
o<chk> endif
M2
