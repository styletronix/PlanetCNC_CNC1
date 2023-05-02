o121 ;Measure Coordinate System

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

G65 P109 Q#<_workoff_useprobe>
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Coordinate System)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
M73
G08 G15 G94

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif

M55P0
M56P0
M57P0
M10P1

o<chk> if[#<_workoff_useprobe>]
  o<useD> if [EXISTS[#<dvalue>]]
    G65 P110 H2 E-1 Q1 R1 D#<dvalue> K#<_workoff_swdist> J#<_probe_sizez> F#<_probe_speed> I#<_probe_speed_low>
  o<useD> else
    G65 P110 H2 E-1 Q1 R1 D#<_probe_length> K#<_workoff_swdist> J#<_probe_sizez> F#<_probe_speed> I#<_probe_speed_low>
  o<useD> endif
o<chk> else
  G65 P110 H2 E-1 Q0 R1 D10000 K#<_workoff_swdist> J#<_workoff_size> F#<_workoff_speed> I#<_workoff_speed_low>
o<chk> endif

o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure Coordinate System Measure error)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<off> = #<_measure_z>
o<chk> if[#<_tooloff> NE 0]
  #<off> = [#<off> - #<_tooloff_z>]
o<chk> endif
#<off> = [#<off> - #<_workoff_z>]
#<off> = [#<off> - #<_warp_offset>]

o<chk> if[#<rvalue> EQ 1]
  o<ochk> if[EXISTS[#<zvalue>]]
    #<off> = [#<off> - #<zvalue>]
  o<ochk> endif

  #<cs> = DEF[#<qvalue>,#<_coordsys>]
  G10 L2 P#<cs> Z#<off>
o<chk> endif

#<_return> = #<off>
M99
