(name,Messe Nut)

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

G65 P109 Q1											;Check Probe
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error.)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<axis> = 1
#<axis2> = 0
#<edgeDist> = 15

M73
G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif

M55 P0
M56 P0
M57 P0
M10 P1

;Punkt 1 Messen
G65 P110 H#<axis> E1 R1
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure1> = #<_measure_axis|#<axis>>


;Punkt 2 Messen
G65 P110 H#<axis> E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure2> = #<_measure_axis|#<axis>>


;Mitte anfahren
#<_measure_axis|#<axis>> = [[#<measure1> + #<measure2>] / 2]
#<_measure_size_axis|#<axis>> = [ABS[#<measure1> - #<measure2>]]
G53 G00 H#<axis> E#<_measure_axis|#<axis>>


#<measure11> = #<_measure_axis|#<axis>>
#<measure12> = #<_measure_axis|#<axis2>>		;#<_machine_x>
(print,|!  Zentrum rechts:  X#<measure12> Y#<measure11>)


;Punkt 3 messen

G65 P110 H#<axis2> E-1 R0
#<point2_x> = #<_measure_axis|#<axis2>>
G53 G00 H#<axis2> E[#<point2_x> + #<edgeDist>]
(print,|!  Linke Kante:  X#<point2_x>)






;Punkt 4 Messen
G65 P110 H#<axis> E1 R1
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure1> = #<_measure_axis|#<axis>>


;Punkt 5 Messen
G65 P110 H#<axis> E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure2> = #<_measure_axis|#<axis>>


;Mitte anfahren
#<_measure_axis|#<axis>> = [[#<measure1> + #<measure2>] / 2]
#<_measure_size_axis|#<axis>> = [ABS[#<measure1> - #<measure2>]]
G53 G00 H#<axis> E#<_measure_axis|#<axis>>

#<measure21> = #<_measure_axis|#<axis>>
#<measure22> = #<_measure_axis|#<axis2>>		;#<_machine_x>
(print,|!  Zentrum links:  X#<measure22> Y#<measure21>)


#<_measure_rot> = [[ATAN2[[#<measure21>-#<measure11>],[#<measure22>-#<measure12>]]] + 180.0]
;0<rotCheck> if [#<_measure_rot> < 0]
;	#<_measure_rot> = [#<_measure_rot> + 360]
;0<rotCheck> endif
(print,|!  Rotation:  #<_measure_rot>)
G10 L20 P#<_coordsys> X0 Y0 R#<_measure_rot>



G65 P110 H#<axis2> E-1 R0
o<chk> if [NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure31> = #<_measure_axis|#<axis>>
#<measure32> = #<_measure_axis|#<axis2>>
(print,|!  Linke Kante:  X#<measure32> Y#<measure31>)

G65 P102 H#<axis2>
$<cmd_setcsoffset>



#<_return> = 0
M99






























o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


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


G65 P160 H1



M2