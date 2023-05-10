(name,Probe Calibration)

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


(dlgname,Probe Calibration)
(dlg,data::MeasureHole, typ=image, x=75)
(dlg,Calibration ring size, typ=label, x=20, color=0xffa500)
(dlg,Size, x=0, dec=5, def='setunit(30, 1);', min=0.1, max=10000, setunits, store, param=size)
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

G65 P108 D#<size>
M2
