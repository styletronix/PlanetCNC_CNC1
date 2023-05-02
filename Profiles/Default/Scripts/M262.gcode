(name,Set Output advanced)


o<chk> if[NOTEXISTS[#<pvalue>] or NOTEXISTS[#<qvalue>]]
	(msg,P oder Q fehlt)
	M02
o<chk> endif


o<outselect> if[[#<pvalue> GE 1] AND [#<pvalue> LE 8]]		;Internal Outputs 1-8
	#<_output_num|#<pvalue>> = #<qvalue>;
	
o<outselect> elseif[[#<pvalue> GE 101] AND [#<pvalue> LE 116]]		;External Outputs 101-116 maps to ExtOut SEL1 1-16
	#<bit> = [#<pvalue>-100]
	#<_extout1_num|#<bit>> = #<qvalue>;
	
o<outselect> elseif[[#<pvalue> GE 201] AND [#<pvalue> LE 216]]		;External Outputs 201-216 maps to ExtOut SEL2 1-16
	#<bit> = [#<pvalue>-200]
	#<_extout2_num|#<bit>> = #<qvalue>;

o<outselect> else
	(msg,Ausgang nicht im gültigen Bereich: #<pvalue>)
	M02
	
o<outselect> endif