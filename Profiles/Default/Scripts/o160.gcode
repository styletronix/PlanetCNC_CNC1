o160 ;Measure Slot
; 2022-02-15   	Changed to work coordinates to respect rotation
; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<axis> = #<hvalue>
#<dist> = DEFNZ[#<dvalue>,10000]

o<chk> if[NOTEXISTS[#<axis>]]
  (msg,Axis value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if[[#<axis> LT 0] OR [#<axis> GT 1]]
  (msg,Axis value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif

M73
G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif

M55P0
M56P0
M57P0
M10P1

G65 P110 H#<axis> E1 R1 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<measure1_0> = #<_measure_axis|0>
#<measure1_1> = #<_measure_axis|1>

G65 P110 H#<axis> E-1 R0 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<measure2_0> = #<_measure_axis|0>
#<measure2_1> = #<_measure_axis|1>

#<_measure_axis|0> = [[#<measure1_0> + #<measure2_0>] / 2]
#<_measure_axis|1> = [[#<measure1_1> + #<measure2_1>] / 2]

#<_measure_size_axis|#<axis>> = [ABS[sqrt[ sqr[#<measure1_0> - #<measure2_0>] + sqr[#<measure1_1> - #<measure2_1>] ]]]
(txt,cmd_moveto,G90 G53 G00 $<axis|0>#<_measure_axis|0> $<axis|1>#<_measure_axis|1>)
G9
$<cmd_moveto>

(print,|!Measure Slot)
G65 P102 H#<axis>
(print,|!  Slot width:)
(print,  $<axis|#<axis>>#<_measure_size_axis|#<axis>>)
#<_return> = 0
M99
