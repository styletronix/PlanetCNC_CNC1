o204 ;probing-xy-circular-boss
; 2022-02-27   	o204 created
; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

o<chk> if[DEF[#<dvalue>,0] LE 0]
  (msg,Fehlerhafter D wert)
  #<_sx_canceled> = 1
  M2
o<chk> endif

G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<radius> = #<dvalue>
#<dist> = DEFNZ[#<evalue>,#<radius>]
#<speed> = [DEFNZ[#<fvalue>,#<_probe_speed>]]
#<depth> = #<hvalue>

M73
G08 G15 G94 G90

O<debug> if[#<_sx_debug> EQ 0]
	M50P0		;Disable Override Feed
O<debug> endif

M55P0
M56P0
M57P0
M10P1

M110 P6 Q1			;Enable probe monitoring
G91 G01 H0 E[-#<radius>] F#<speed>
G91 G01 H2 E[-#<depth>] F#<speed>
G65 P110 H0 E1 R1 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure01_x> = #<_measure_x>
#<measure01_y> = #<_measure_y>
M110 P7 Q1			;Disable probe monitoring
G91 G01 H2 E[#<depth>] F#<_speed_traverse>
G91 G01 H0 E[#<radius>] F#<_speed_traverse>


M110 P6 Q1			;Enable probe monitoring
G91 G01 H0 E[#<radius>] F#<speed>
G91 G01 H2 E[-#<depth>] F#<speed>
G65 P110 H0 E-1 R1 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure02_x> = #<_measure_x>
#<measure02_y> = #<_measure_y>
M110 P7 Q1			;Disable probe monitoring
G91 G01 H2 E[#<depth>] F#<_speed_traverse>
G90 G53 G01 X[[#<measure01_x> + #<measure02_x>] / 2] Y[[#<measure01_y> + #<measure02_y>] / 2] F#<_speed_traverse>


M110 P6 Q1			;Enable probe monitoring
G91 G01 H1 E[-#<radius>] F#<speed>
G91 G01 H2 E[-#<depth>] F#<speed>
G65 P110 H1 E1 R1 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure11_x> = #<_measure_x>
#<measure11_y> = #<_measure_y>
M110 P7 Q1			;Disable probe monitoring
G91 G01 H2 E[#<depth>] F#<_speed_traverse>
G91 G01 H1 E[#<radius>] F#<_speed_traverse>


M110 P6 Q1			;Enable probe monitoring
G91 G01 H1 E[#<radius>] F#<speed>
G91 G01 H2 E[-#<depth>] F#<speed>
G65 P110 H1 E-1 R1 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure12_x> = #<_measure_x>
#<measure12_y> = #<_measure_y>
M110 P7 Q1			;Disable probe monitoring
G91 G01 H2 E[#<depth>] F#<_speed_traverse>
G90 G53 G01 X[[#<measure11_x> + #<measure12_x>] / 2] Y[[#<measure11_y> + #<measure12_y>] / 2] F#<_speed_traverse>


M110 P6 Q1			;Enable probe monitoring
G91 G01 H0 E[-#<radius>] F#<speed>
G91 G01 H2 E[-#<depth>] F#<speed>
G65 P110 H0 E1 R1 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure01_x> = #<_measure_x>
#<measure01_y> = #<_measure_y>
M110 P7 Q1			;Disable probe monitoring
G91 G01 H2 E[#<depth>] F#<_speed_traverse>
G91 G01 H0 E[#<radius>] F#<_speed_traverse>

M110 P6 Q1			;Enable probe monitoring
G91 G01 H0 E[#<radius>] F#<speed>
G91 G01 H2 E[-#<depth>] F#<speed>
G65 P110 H0 E-1 R0 D#<dist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure02_x> = #<_measure_x>
#<measure02_y> = #<_measure_y>
M110 P7 Q1			;Disable probe monitoring
G91 G01 H2 E[#<depth>] F#<_speed_traverse>


#<_measure_x> = [[#<measure01_x> + #<measure02_x>] / 2]
#<_measure_y> = [[#<measure11_y> + #<measure12_y>] / 2]
#<_measure_sizex> = [ABS[#<measure01_x> - #<measure02_x>]]
#<_measure_sizey> = [ABS[#<measure11_y> - #<measure12_y>]]
#<_measure_sizex> = [SQRT[SQR[#<_measure_sizex>] + SQR[#<_measure_sizey>]]]
#<_measure_sizey> = #<_measure_sizex>

G90 G53 G01 X#<_measure_x> Y#<_measure_y> F#<_speed_traverse>

(print,|!Measure circular boss)
G65 P102 J0 K0
(print,|!  Durchmesser:)
(print,  X#<_measure_sizex> Y#<_measure_sizey>)

#<_return> = 0
M99
