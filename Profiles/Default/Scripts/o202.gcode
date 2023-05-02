o202 ;Measure Rectangle
; 2022-02-19 	o202 created
; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<distX> = DEFNZ[#<dvalue>,10000]
#<distY> = DEFNZ[#<evalue>,10000]

M73
G08 G15 G94 G90

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif

M55P0
M56P0
M57P0
M10P1


G65 P160 H0 D#<distX>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure1_0> = #<_measure_axis|0>
#<measure1_1> = #<_measure_axis|1>
#<measure1_size> = #<_measure_size_axis|0>

G65 P160 H1 D#<distY>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Slot)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure2_0> = #<_measure_axis|0>
#<measure2_1> = #<_measure_axis|1>
#<measure2_size> = #<_measure_size_axis|1>



#<_measure_sizex> = #<measure1_size>
#<_measure_sizey> = #<measure2_size>
#<_measure_axis|0> = #<measure2_0>
#<_measure_axis|1> = #<measure2_1>
#<_return> = 1
#<_measure> = 1

(txt,cmd_moveto,G90 G53 G00 $<axis|0>#<_measure_axis|0> $<axis|1>#<_measure_axis|1>)
M110 P7 	;Probe disable
G90 G53 G00 X#<_measure_axis|0> Y#<_measure_axis|1>

(print,|!Measure Rectangle)
;G65 P102 J0 K0
(print,|!  Rectangle size:)
(print,  X#<_measure_sizex> Y#<_measure_sizey>)
#<_return> = 0
M99
