(name,Niederhalter)

; 2022-06-01	M62 durch _output_num ersetzt.
; 2022-08-17	Kommentarausgabe hinzugefügt

O<debug> if[#<_sx_debug> NE 0]
	(print,M100  Niederhalter)
O<debug> endif


G09
o<chk> if[NOTEXISTS[#<qvalue>]]
	o<check2> if [#<_hw_output_num|#<_sx_niederhalter_pin>> EQ 1]
		#<qvalue> = 0
	o<check2> else
		#<qvalue> = 1
	o<check2> endif
o<chk> endif

o<dwn> if [[#<qvalue> EQ 1] AND [#<_hw_output_num|#<_sx_niederhalter_pin>> NE 1 ]]
	;M62 P#<_sx_niederhalter_pin> Q1
	#<_output_num|#<_sx_niederhalter_pin>> = 1
	M103 P#<_sx_niederhalter_oben_input> Q0 R3.0 

o<dwn> elseif [[#<qvalue> EQ 0] AND [#<_hw_output_num|#<_sx_niederhalter_pin>> NE 0 ]]
	;M62 P#<_sx_niederhalter_pin> Q0
	o<ausblasen> if [#<_sx_ausblasen_pin_ext1> GT 0]
		#<_extout1_num|#<_sx_ausblasen_pin_ext1>> = 1
		G04 P0.2
	o<ausblasen> endif
	
	#<_output_num|#<_sx_niederhalter_pin>> = 0
	
	;O<chk> if [[#<_sx_niederhalter_oben_input> GT 0] AND [#<_hw_sim> NE 1]]
		M103 P#<_sx_niederhalter_oben_input> Q1 R5.0 
		o<ausblasen> if [#<_sx_ausblasen_pin_ext1> GT 0]
			#<_extout1_num|#<_sx_ausblasen_pin_ext1>> = 0
		o<ausblasen> endif
    ;O<chk> endif
o<dwn> endif