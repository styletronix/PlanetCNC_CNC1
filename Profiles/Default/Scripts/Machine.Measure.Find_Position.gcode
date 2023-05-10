(name,Find Position)
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

  o<chk> if [#<_prog_linecount> EQ 0]
    (msg,Can not perform action without loaded program)
    M2
  o<chk> endif

(dlgname,Find Position)
(dlg,Origin|None|\ | |\~ |\ | , typ=checkbox, x=20, w=50, def=1, store, param=origin)
(dlg,Action|Move|Set Offset, typ=checkbox, x=20, w=75, def=1, param=act)
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

#<sx> = [#<_machine_x>]
#<sy> = [#<_machine_y>]
o<org> if [#<origin> EQ 1]
  o<act> if [AND[#<act>, 1]]
    (print,x: 0, y: 0)
    G53 G00 X#<_prog_minfeed_x> Y#<_prog_minfeed_y>
    G53 G00 X#<_prog_minfeed_x> Y#<_prog_maxfeed_y>
    G53 G00 X#<_prog_maxfeed_x> Y#<_prog_maxfeed_y>
    G53 G00 X#<_prog_maxfeed_x> Y#<_prog_minfeed_y>
    G53 G00 X#<_prog_minfeed_x> Y#<_prog_minfeed_y>
  o<act> endif
o<org> elseif [#<origin> EQ 2]
  #<dx> = [#<_machine_x> - #<_prog_minfeed_x>]
  #<dy> = [#<_machine_y> - #<_prog_maxfeed_y>]
  o<act> if [AND[#<act>, 1]]
    (print,x: #<dx>, y: #<dy>)
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
  o<act> endif
o<org> elseif [#<origin> EQ 3]
  #<dx> = [#<_machine_x> - #<_prog_maxfeed_x>]
  #<dy> = [#<_machine_y> - #<_prog_maxfeed_y>]
  o<act> if [AND[#<act>, 1]]
    (print,x: #<dx>, y: #<dy>)
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
  o<act> endif
o<org> elseif [#<origin> EQ 4]
  #<dx> = [#<_machine_x> - [#<_prog_maxfeed_x> + #<_prog_minfeed_x>]/2 ]
  #<dy> = [#<_machine_y> - [#<_prog_maxfeed_y> + #<_prog_minfeed_y>]/2 ]
  o<act> if [AND[#<act>, 1]]
    (print,x: #<dx>, y: #<dy>)
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X#<sx> Y #<sy>
  o<act> endif
o<org> elseif [#<origin> EQ 5]
  #<dx> = [#<_machine_x> - #<_prog_minfeed_x>]
  #<dy> = [#<_machine_y> - #<_prog_minfeed_y>]
  o<act> if [AND[#<act>, 1]]
    (print,x: #<dx>, y: #<dy>)
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
  o<act> endif
o<org> elseif [#<origin> EQ 6]
  #<dx> = [#<_machine_x> - #<_prog_maxfeed_x>]
  #<dy> = [#<_machine_y> - #<_prog_minfeed_y>]
  o<act> if [AND[#<act>, 1]]
    (print,x: #<dx>, y: #<dy>)
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_maxfeed_y>+#<dy>]
    G53 G00 X[#<_prog_minfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
    G53 G00 X[#<_prog_maxfeed_x>+#<dx>] Y[#<_prog_minfeed_y>+#<dy>]
  o<act> endif
o<org> endif

o<act> if [AND[#<act>, 2]]
  o<chk> if[EXISTS[#<dx>] AND EXISTS[#<dy>]]
    G92.1 X[#<_workoff_x>+#<dx>] Y[#<_workoff_y>+#<dy>]
  o<chk> endif
o<act> endif
M2


