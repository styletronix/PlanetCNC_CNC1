o131 ;Measure Edge Find

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Edge Find)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<axis> = #<hvalue>
#<dir> = #<evalue>
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
o<chk> if[NOTEXISTS[#<dir>]]
  (msg,Direction value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if[[#<dir> EQ -1] XNOR [#<dir> EQ 1]]
  (msg,Direction value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif

o<chk> if[NOTEXISTS[#<dist>] OR [#<dist> LE 0]]
  (msg,Distance value incorrect)
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

o<meas> if[NOTEXISTS[#<kvalue>]]
G65 P110 H2 E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Edge Find)
  #<_sx_canceled> = 1
  M2
o<chk> endif

  #<measureZ> = #<_measure_z>
o<meas> else
  #<measureZ> = #<kvalue>
o<meas> endif
#<travelZ> = [#<measureZ> + #<_probe_trav> + #<_probe_sizez>]
G53 G00 Z#<travelZ>
G91 G53 G00 H#<axis> E[#<dir> * [#<dist> + 2*#<_probe_size_axis|#<axis>>]]
G90
o<mov> while[1]
  M11P0
  G53 G38.3 Z[#<measureZ> - #<_probe_trav>] F#<_probe_speed>
  o<chk> if[LNOT[#<_probe>]]
    M11P1
    o<mov> break
  o<chk> endif
  G91 G53 G00 Z#<_probe_swdist>
  G90
  M11P1
  G53 G00 Z#<travelZ>
  G91 G53 G00 H#<axis> E[#<dir> * [#<dist>/4 + 2*#<_probe_size_axis|#<axis>>]]
  G90
o<mov> endwhile

#<_return> = 0
M99
