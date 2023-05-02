(name,Schwenkantrieb für Ölschlauch)

; 2022-06-01	M62 durch _output_num ersetzt.

#<delay_off> = 0.0
#<delay_on> = DEF[#<pvalue>,1.0] 

o<chk> if[NOTEXISTS[#<qvalue>]]
	o<check2> if [#<_hw_output_num|#<_sx_schwenkantrieb_output>> EQ 1]
		#<qvalue> = 0
	o<check2> else
		#<qvalue> = 1
	o<check2> endif
o<chk> endif

o<dwn> if [[#<qvalue> EQ 1] and [#<_hw_output_num|#<_sx_schwenkantrieb_output>> NE 1]]
	(print, Schwenkantrieb an)
	;M62 P#<_sx_schwenkantrieb_output> Q1
	#<_output_num|#<_sx_schwenkantrieb_output>> = 1;
	G04 P#<delay_on>
	
o<dwn> elseif [[#<qvalue> EQ 0] and [#<_hw_output_num|#<_sx_schwenkantrieb_output>> NE 0]]
	(print, Schwenkantrieb aus)
	;M62 P#<_sx_schwenkantrieb_output> Q0
	#<_output_num|#<_sx_schwenkantrieb_output>> = 0;
	G04 P#<delay_off>
	
o<dwn> endif