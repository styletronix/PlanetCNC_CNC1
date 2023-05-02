o102 ;Offset calculation

;2022-02-18			Add WCS calculation for rotation
;					Support for XY offset using J and K without H
;					Support for single axis offset using J
;2022-06-05			Deutsche Textausgabe
;					cmd_setworkoffset hinzugefügt

#<axis> = DEF[#<hvalue>,0]
#<dir> = #<evalue>
#<workOffset> = [DEF[#<jvalue>,0]]
#<machine_rot> = [#<_coordsys_rot> + #<_axisrot_ang>]						;Rotation Machine / Current WCS

o<chk> if [NOTEXISTS[#<hvalue>] AND [NOTEXISTS[#<jvalue>] OR NOTEXISTS[#<kvalue>]]]
  (msg,Axis value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [[#<axis> LT 0] OR [#<axis> GT 2]]
  (msg,Axis value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Messfehler: Offset berechnen)
  #<_sx_canceled> = 1
  M2
o<chk> endif


;BEGIN Calculate Machine/Measure -> WCS Position  --------------------------------
	#<diff0> = [#<_measure_axis|0> - #<_coordsys_axis|0>]
	#<diff1> = [#<_measure_axis|1> - #<_coordsys_axis|1>]
	#<off_rot> = 0
	o<chk> if [[#<diff1> NE 0] OR [#<diff0> NE 0]]
		#<off_rot> = [atan2[#<diff1>,#<diff0>]]	
	o<chk> endif
	#<off_rot> =  [90 + #<machine_rot> - #<off_rot>]			
	#<diff_T> = [sqrt[sqr[#<diff0>] + sqr[#<diff1>]]]
	#<wcs0> = [#<diff_T> * sin[#<off_rot>]]
	#<wcs1> = [#<diff_T> * sin[90 - #<off_rot>]]
	#<wcs2> = [#<_measure_axis|2> - #<_coordsys_axis|2> - #<_warp_offset>]	;WCS Z
	(print, Arbeitsposition X#<wcs0> Y#<wcs1> Z#<wcs2>)
;END Calculate Machine/Measure -> WCS Position  --------------------------------

; TODO: Add WCS desired difference with  M111 P0-P2 Q...

;BEGIN Select wcs coordinate based on optional J and K value (J workoffset probing axis -- K workoffset other axis in XY Mode)
o<axNum> if [#<axis> EQ 0]
	#<wcs0> = [DEF[#<jvalue>,0]]	
	#<wcs1> = [DEF[#<kvalue>,#<wcs1>]]
o<axNum> elseif [#<axis> EQ 1]
	#<wcs0> = [DEF[#<kvalue>,#<wcs0>]]
	#<wcs1> = [DEF[#<jvalue>,0]]	
o<axNum> else
	#<wcs2> = [DEF[#<jvalue>,0]]	
o<axNum> endif

(print,   Erwartete Arbeitsposition nach Kompensation: X#<wcs0> Y#<wcs1> Z#<wcs2>)
;END

;BEGIN Calculate WCS Position -> Machine/Measure
	#<diff_T> = [sqrt[sqr[#<wcs0>] + sqr[#<wcs1>]]]
	#<off_rot> = 0
	o<chk> if [[#<wcs1> NE 0] OR [#<wcs0> NE 0]]
		#<off_rot> = [atan2[#<wcs1>,#<wcs0>]]	
	o<chk> endif	
	#<off_rot> =  [#<off_rot> + #<machine_rot>]	
	#<csZero0> = [#<_measure_axis|0> - #<diff_T> * cos[#<off_rot>]]
	#<csZero1> = [#<_measure_axis|1> - #<diff_T> * sin[#<off_rot>]]
	#<csZero2> = [#<_measure_axis|2> - #<wcs2>]
	(print,  CS 0-Position X#<csZero0> Y#<csZero1> Z#<csZero2>)
;END

;BEGIN Create CMD for WorkOffset, CsOffset and MoveTo
o<axNum> if [#<axis> EQ 2]
	(txt,cmd_setcsoffset,G10 L2 P#<_coordsys> $<axis|2>#<csZero2>)

o<axNum> else
	(txt,cmd_moveto,G90 G53 G00 $<axis|0>#<_measure_axis|0> $<axis|1>#<_measure_axis|1>)
	(txt,cmd_movetoZero,G90 G53 G00 $<axis|0>#<csZero0> $<axis|1>#<csZero1>)
	(txt,cmd_setcsoffset,G10 L2 P#<_coordsys> $<axis|0>#<csZero0> $<axis|1>#<csZero1>)
	
	#<m0> = [EXPR[toworkxy(#<csZero0>, #<csZero1>, 0)]]
	#<m1> = [EXPR[toworkxy(#<csZero0>, #<csZero1>, 1)]]
	(txt,cmd_setworkoffset,G92.1 $<axis|0>#<m0> $<axis|1>#<m1>)
o<axNum> endif
;END Create CMD for WorkOffset, CsOffset and MoveTo ---------------------------

;BEGIN Output Commands
o<axNum> if [#<axis> EQ 2]
	(print,|!  Setze Coordinatensystem #<_coordsys>:)
	(print,  $<cmd_setcsoffset>)
o<axNum> else
	(print,|!  Setze Arbeitsposition:)
	(print,  $<cmd_setworkoffset>)
	
	(print,|!  Setze Coordinatensystem #<_coordsys>:)
	(print,  $<cmd_setcsoffset>)
	
	(print,|!  Fahre zur Messposition:)
	(print,  $<cmd_moveto>)
	
	(print,|!  Fahre zum gemessenen Null-Punkt:)
	(print,  $<cmd_movetoZero>)
o<axNum> endif
;END

M99