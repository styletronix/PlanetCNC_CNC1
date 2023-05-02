o201 ;Find switch
#<_return> = NAN[]

o<chk> if [LNOT[ACTIVE[]]]
  M99
o<chk> endif

#<axis> = #<hvalue>					
#<pin> = #<rvalue>
#<type> = #<qvalue>		;0 = Limit Pins / 1 = Input-Pins
#<dir> = #<evalue>
#<step> = DEFNZ[#<jvalue>,0.002]
#<feed> = DEFNZ[#<fvalue>,1000]
#<feed_slow> = DEFNZ[#<kvalue>,50]
#<dist> = DEFNZ[#<dvalue>,100]			
#<back> = DEFNZ[#<mvalue>,2]			;M Distance backwards on limit search

;BEGIN Startbedingungen
o<chk> if [NOTEXISTS[#<pin>]]
  (msg,Pin value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [NOTEXISTS[#<type>]]
	
  (msg,Type value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [[#<type> LT 0] OR [#<type> GT 1]]
  (msg,Type value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [NOTEXISTS[#<axis>]]
  (msg,Axis value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [[#<axis> LT 0] OR [#<axis> GT 2]]
  (msg,Axis value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [NOTEXISTS[#<dir>]]
  (msg,Direction value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [[#<dir> EQ -1] XNOR [#<dir> EQ 1]]
  (msg,Direction value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
;END

M73					;Store Modal with auto-restore
O<debug> if [#<_sx_debug> EQ 0]
	M50 P0			;Disable Override Feed
O<debug> endif
G91 G91.1 G91.2 	;XYZ Incremental / IJK Incremental / ABC Incremental
M11 P0				;Disable limits
M52 P1 Q32			;Set Buffer to 32 for faster response

#<maxpos> = [#<_work_axis|#<axis>> + #<dist>]
#<minpos> = [#<_work_axis|#<axis>> - #<dist>]

o<typeSelect> if [#<type> EQ 0]
	;Find switch ------------------------------------
	o<loop> while [[#<_hw_limit> EQ 0] and [#<_work_axis|#<axis>> LT #<maxpos>] and [#<_work_axis|#<axis>> GT #<minpos>]]
		G1 H#<axis> E[#<step> * #<dir>] F#<feed>
	o<loop> endwhile
	o<chkpin> if [#<_hw_limit_num|#<pin>> NE 1]
		(print,Endschalter wurde nicht erreicht.)
		(msg,Endschalter wurde nicht erreicht.)
		#<_sx_canceled> = 1
		M2
	o<chkpin> endif
	
	;Move back --------------------------
	o<backmove> if [#<back> GT 0]
		G04 P0.2
		G1 H#<axis> E[#<back> * #<dir> * -1] F#<feed>
		
		o<chkpin> if [#<_hw_limit_num|#<pin>> EQ 1]
			(print,Endschalter wurde nicht deaktiviert.)
			(msg,Endschalter wurde nicht deaktiviert.)
			
			#<_sx_canceled> = 1
			M2
		o<chkpin> endif
	o<backmove> endif
	
	#<_return> = 1
	
o<typeSelect> elseif [#<type> EQ 1]	
	#<probe_pins> =  [OR[#<_probe_pin_1>,#<_probe_pin_2>]]

	;Find switch ------------------------------------
	o<loop> while [[#<_hw_input_num|#<pin>> NE 1] and [And[#<_hw_input>,#<probe_pins>] EQ 0] and [#<_work_axis|#<axis>> LT #<maxpos>] and [#<_work_axis|#<axis>> GT #<minpos>]]
		G1 H#<axis> E[#<step> * #<dir>] F#<feed>
	o<loop> endwhile
	
	;Check switch -----------------------------------
	o<chkpin> if [#<_hw_input_num|#<pin>> NE 1]
		(print,Endschalter wurde nicht erreicht.)
		(msg,Endschalter wurde nicht erreicht.)
		#<_sx_canceled> = 1
		M2
	o<chkpin> endif
	
	#<_return> = 1
o<typeSelect> endif


M99 