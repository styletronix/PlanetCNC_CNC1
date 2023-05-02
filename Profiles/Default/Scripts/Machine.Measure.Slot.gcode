(name,Measure Slot)

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


(dlgname,Measure Slot)
(dlg,Select slot orientation, typ=label, x=20, color=0xffffff)
(dlg,data::MeasureSlot, typ=image, x=20)
(dlg,|X|Y, typ=checkbox, x=50, w=110, def=1, store, param=orient)
(dlgshow)

M73
G17 G90 G91.1 G90.2 G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif

M55P0
M56P0
M57P0
M10P1
M11P1

o<st> if [#<orient> EQ 1]
  #<axis> = 0
o<st> elseif [#<orient> EQ 2]
  #<axis> = 1
o<st> else
  (msg,Error)
  #<_sx_canceled> = 1
  M2
o<st> endif

G65 P160 H#<axis>
M2