(name,Measure Surface)
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


(dlgname,Measure Surface)
(dlg,data::MeasureSurface, typ=image, x=0)
(dlg,Size, typ=label, x=20, color=0xffa500)
(dlg,X, x=0, dec='setunit(1,2);', def='setunit(40,1.5);', min='setunit(1,0.1);', max=10000, setunits, store, param=sizeX)
(dlg,Y, x=0, dec='setunit(1,2);', def='setunit(30,1.0);', min='setunit(1,0.1);', max=10000, setunits, store, param=sizeY)
(dlg,Step, typ=label, x=20, color=0xffa500)
(dlg,X, x=0, dec='setunit(1,2);', def='setunit(5,0.25);', min='setunit(0.1,0.01);', max=10000, setunits, store, param=stepX)
(dlg,Y, x=0, dec='setunit(1,2);', def='setunit(5,0.25);', min='setunit(0.1,0.01);', max=10000, setunits, store, param=stepY)
(dlg,|Exact Step, typ=checkbox, x=80, def=1, store, param=exact)
(dlg,Return distance, typ=label, x=20, color=0xffa500)
(dlg,, x=80, dec='setunit(1,2);', def='setunit(3,0.125);', min='setunit(0.1,0.01);', max=200, setunits, store, param=return)
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

(pointsclear)
#<startX> = #<_machine_x>
#<startY> = #<_machine_y>

#<cntX> = ROUNDUP[#<sizeX> / #<stepX>]
#<cntY> = ROUNDUP[#<sizeY> / #<stepY>]
o<chk> if [#<exact> EQ 0]
  #<stepX> = [#<sizeX> / #<cntX>]
  #<stepY> = [#<sizeY> / #<cntY>]
o<chk> endif
#<sizeX> = [#<cntX> * #<stepX>]
#<sizeY> = [#<cntY> * #<stepY>]
(print,|!Measure Surface)
(print,  cntX=#<cntX,2>, cntY=#<cntY,2>)
(print,  sizeX=#<sizeX,2>, sizeY=#<sizeY,2>)
(print,  stepX=#<stepX,2>, stepY=#<stepY,2>)
#<dir> = 1
#<currY> = 0
o<loopy> while [1]
  #<currX> = 0
  o<loopx> while [1]

    G65 P110 H2 E-1
    o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
      (msg,Measure error)
      M2
    o<chk> endif

    #<posx> = #<_machine_x>
    #<posy> = #<_machine_y>
    (point,X#<posx> Y#<posy> Z#<_measure_z>)
    G91 G53 G00 Z#<return>
    G90
    #<currX> = [#<currX>+1]
    o<chk> if[#<currX> GT #<cntX>]
      o<loopx> break
    o<chk> endif
    G91 G53 G00 X[#<dir> * #<stepX>]
    G90
  o<loopx> endwhile
  #<currY> = [#<currY>+1]
  o<chk> if[#<currY> GT #<cntY>]
    o<loopy> break
  o<chk> endif
    G91 G53 G00 Y[#<stepY>]
    G90
  #<dir> = [-#<dir>]
o<loopy> endwhile

(print,  Number of points: #<_pointcnt,0>)

G53 G00 Z#<_probe_safeheigh>

M2
