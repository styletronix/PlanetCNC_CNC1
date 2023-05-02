o135 ;Messe Winkel

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

(print,Messe Winkel:)

G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Sensor fehler: Messe Winkel)
  #<_sx_canceled> = 1
  M2
o<chk> endif

#<_return> = NAN[]
#<axis> = #<hvalue>
#<dir> = #<evalue>
#<measuredist> = [DEF[#<qvalue>,1000]]
#<dist> = #<dvalue>
#<feed> = DEFNZ[#<fvalue>,#<_probe_speed>]
#<minRot> = #<jvalue>
#<maxRot> = #<kvalue>
#<toolRot> = [DEF[#<mvalue>,0]]

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
o<chk> if[NOTEXISTS[#<dist>]]
  (msg,Dist value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif

o<chk> if[[#<axis> EQ 0] AND [#<dir> EQ +1]]
  #<axis2> = 1
  #<travelAngle> = [DEF[#<mvalue>,90]]
  #<dist> = [#<dist> / cos[#<travelAngle> - 90]]
o<chk> elseif[[#<axis> EQ 0] AND [#<dir> EQ -1]]
  #<axis2> = 1
  #<travelAngle> = [DEF[#<mvalue>,90]]
  #<dist> = [#<dist> / cos[#<travelAngle> - 90]]
o<chk> elseif[[#<axis> EQ 1] AND [#<dir> EQ +1]]
  #<axis2> = 0
  #<travelAngle> = [DEF[#<mvalue>,0]]
  #<dist> = [#<dist> / cos[#<travelAngle>]]
o<chk> elseif[[#<axis> EQ 1] AND [#<dir> EQ -1]]
  #<axis2> = 0
  #<travelAngle> = [DEF[#<mvalue>,0]]
  #<dist> = [#<dist> / cos[#<travelAngle>]]
o<chk> else
  (msg,Axis and/or Dir values incorrect)
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

M110 P6		;Monitoring Probe
G91 G01 @[#<dist> * -1 / 2]^#<travelAngle> F#<feed>
G90

G65 P110 H#<axis> E#<dir> R1 D#<measuredist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Messfehler: Messe Winkel Punkt 1)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure1_0> = #<_measure_axis|0>
#<measure1_1> = #<_measure_axis|1>



G91 G01 @[#<dist>]^#<travelAngle> F#<feed>
G90

G65 P110 H#<axis> E#<dir> R1 D#<measuredist>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Messfehler: Messe Winkel Punkt 2)
  #<_sx_canceled> = 1
  M2
o<chk> endif
#<measure2_0> = #<_measure_axis|0>
#<measure2_1> = #<_measure_axis|1>


G91 G01 @[#<dist> * -1 / 2]^#<travelAngle> F#<feed>
G90



#<_measure_size_axis|0> = [#<measure2_0> - #<measure1_0>]
#<_measure_size_axis|1> = [#<measure2_1> - #<measure1_1>]
#<_measure_axis|0> = [#<measure1_0> + [#<_measure_size_axis|0> / 2]]
#<_measure_axis|1> = [#<measure1_1> + [#<_measure_size_axis|1> / 2]]
#<_measure_rot> = [ATAN2[#<_measure_size_axis|1> , #<_measure_size_axis|0>]]
#<_measure_coordsys_rot> = [#<_measure_rot> - #<_coordsys_rot> - #<_axisrot_ang>]

(print,|!Winkel CCW $<axis|0>+=0:)
(print, 	Maschine: #<_measure_rot> Grad)
(print, 	Koordinate: #<_measure_coordsys_rot> Grad)
(print,   Punkt 1: $<axis|0>#<measure1_0> $<axis|1>#<measure1_1>)
(print,   Punkt 2: $<axis|0>#<measure2_0> $<axis|1>#<measure2_1>)
(print,   Size: $<axis|0>#<_measure_size_axis|0> $<axis|1>#<_measure_size_axis|1>)

o<chk> if [exists[#<minRot>]]
	o<chk2> if [#<minRot> GT #<_measure_coordsys_rot>]
		(msg,Messfehler: Der gemessene Winkel liegt nicht innerhalb der Toleranz. IST: #<_measure_coordsys_rot>  SOLL-Min: > #<minRot>)
		#<_sx_canceled> = 1
		M2
	o<chk2> endif
o<chk> endif
o<chk> if [exists[#<maxRot>]]
	o<chk2> if [#<maxRot> LT #<_measure_coordsys_rot>]
		(msg,Messfehler: Der gemessene Winkel liegt nicht innerhalb der Toleranz. IST: #<_measure_coordsys_rot>  SOLL: < #<maxRot>)
		#<_sx_canceled> = 1
		M2
	o<chk2> endif
o<chk> endif

(txt,cmd_setcsoffset,G10 L2 P#<_coordsys> R#<_measure_rot>)
(print, Set CS Offset:)
(print, $<cmd_setcsoffset>)

#<_return> = 1
M99
