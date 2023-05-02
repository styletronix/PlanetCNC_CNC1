o103 ;Measure XY

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

; #<_measure_axis|0> = #<_measure_x>
; #<_measure_axis|1> = #<_measure_y>
; G65 P102 H[DEF[#<hvalue>,0]] E[DEF[#<evalue>,1]] J[DEF[#<jvalue>,0]] K[DEF[#<kvalue>,0]]
; M99

#<workTargetX> = [DEF[#<jvalue>,0]]
#<workTargetY> = [DEF[#<kvalue>,0]]

#<posx> = #<_measure_x>
#<posy> = #<_measure_y>
(txt,cmd_moveto,G53 G00 X#<posx> Y#<posy>)

(print,|!  Machine coordinate:)
(print,  X#<posx> Y#<posy>)

(print,|!  Work coordinate:)
#<poswx> = TOWORK[#<posx>,0]
#<poswy> = TOWORK[#<posy>,1]
(print,  X#<poswx> Y#<poswy>)

#<poswx> = [EXPR[toworkxy(#<posx>, #<posy>, 0)]]
#<poswy> = [EXPR[toworkxy(#<posx>, #<posy>, 1)]]
(print,  X#<poswx> Y#<poswy>)

#<deltax> = [#<posx> + #<_operator_x>]
#<deltay> = [#<posy> + #<_operator_y>]

(print,|!  Operator delta:)
(print,  X#<deltax> Y#<deltay>)
#<_operator_x> = -#<posx>
#<_operator_y> = -#<posy>

#<offx> = #<posx>
#<offy> = #<posy>

o<chk> if[#<_tooloff> NE 0]
  #<offx> = [#<offx> - #<_tooloff_x>]
  #<offy> = [#<offy> - #<_tooloff_y>]
o<chk> endif

#<offwx> = [#<offx> - #<_coordsys_x>]
#<offwy> = [#<offy> - #<_coordsys_y>]
#<offcx> = [#<offx> - #<_workoff_x>]
#<offcy> = [#<offy> - #<_workoff_y>]
#<global_rot> = [#<_coordsys_rot> - #<_axisrot_ang>]

(msg,TODO: Winkelkorrektur noch nicht fertig)
	o<chk> if[[#<workTargetX> NE 0] OR [#<workTargetY> NE 0]]
		#<offExtendy> = [[sin[#<global_rot>] * #<workTargetX>] + [sin[#<global_rot> - 90] * #<workTargetY>]]
		#<offExtendx> = [[cos[#<global_rot>] * #<workTargetX>] + [cos[#<global_rot> - 90] * #<workTargetY>]]
		
		(print, zusätzliches Offset nach Winkelkorrektur: X#<offExtendx> Y#<offExtendy>)
		
		#<offwx> = [#<offwx> + #<offExtendx>]
		#<offwy> = [#<offwy> + #<offExtendy>]
		#<offcx> = [#<offcx> + #<offExtendx>]
		#<offcy> = [#<offcy> + #<offExtendy>]
	o<chk> endif

(txt,cmd_setworkoffset,G92.1 X#<offwx> Y#<offwy>)
(txt,cmd_setcsoffset,G10 L2 P#<_coordsys> X#<offcx> Y#<offcy>)

(print,|!  Set work position:)
(print,  $<cmd_setworkoffset>)
(print,|!  Set coordinate system #<_coordsys>:)
(print,  $<cmd_setcsoffset>)
(print,|!  Move To:)
(print,  $<cmd_moveto>)
M99
