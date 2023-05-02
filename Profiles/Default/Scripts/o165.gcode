o165 ;Measure Tab

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Tab)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<axis> = #<hvalue>
#<dist> = #<dvalue>
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
o<chk> if[NOTEXISTS[#<dist>] OR [#<dist> LE 0]]
  (msg,Size value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
M73
G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif

M55 P0
M56 P0
M57 P0
M10 P1

#<pos> = #<_machine_axis|#<axis>>
G65 P131 H#<axis> E1 D[#<dist>/2]
#<measureZ> = #<_measure_z>
#<travelZ> = [#<measureZ> + #<_probe_trav> + #<_probe_sizez>]
G65 P110 H#<axis> E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Tab)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<measure1> = #<_measure_axis|#<axis>>

G53 G00 Z#<travelZ>
G53 G00 H#<axis> E#<pos>
G65 P131 H#<axis> E-1 D[#<dist>/2] K#<measureZ>
G65 P110 H#<axis> E1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Tab)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<measure2> = #<_measure_axis|#<axis>>

G53 G00 Z#<travelZ>
#<_measure_axis|#<axis>> = [[#<measure1> + #<measure2>] / 2]
#<_measure_size_axis|#<axis>> = [ABS[#<measure1> - #<measure2>]]
G53 G00 H#<axis> E#<_measure_axis|#<axis>>

(print,|!Measure Tab)
G65 P102 H#<axis>
(print,|!  Tab width:)
(print,  $<axis|#<axis>>#<_measure_size_axis|#<axis>>)
#<_return> = 0
M99
