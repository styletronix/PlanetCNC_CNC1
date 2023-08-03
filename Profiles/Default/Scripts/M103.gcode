;Auf Eingang warten
; 2022-07-17	Option zum erneuten Versuch
; 2023-08-02	Optimierung und G9 hinzugefügt

;M103 P<Eingang> Q<Warte auf Wert Q> R<Timeout in Sekunden - Optional>)

#<timeout> =  DEF[#<rvalue>,60.0]
#<_return> = NAN[]
#<stoponerror> = DEF[#<dvalue>,1]

G9	;Synchronisiere mit Controller

o<chk> if [NOTEXISTS[#<pvalue>] OR NOTEXISTS[#<qvalue>]]
	(msg,Parameter P oder Q fehlt)
	#<_sx_canceled> = 1
	M02
o<chk> endif

o<chk> if [#<_hw_sim> EQ 1]
	(print,Warte auf Eingang #<pvalue> wurde übersprungen da Simulation aktiv ist.)
	#<_return> = -1
	M99
o<chk> endif

#<exit>=1

o<lpp> do
#<timeoutTime> = [DATETIME[] + #<timeout>]

(print,Warte auf Wert #<qvalue> am Eingang #<pvalue>...  Aktueller Status #<_hw_input_num|#<pvalue>>)

O<loop> do
	O<ifblock> if [#<_hw_input_num|#<pvalue>> EQ #<qvalue>]
		(print,Eingang #<pvalue> hat Status #<_hw_input_num|#<pvalue>> erreicht.)
		#<_return> = #<_hw_input_num|#<pvalue>>
		#<exit>=1
		M99	
	O<ifblock> endif	
	G04	P0.1
O<loop> while [#<timeoutTime> GE DATETIME[]]

#<_return> = NAN[]

O<chk> if [#<stoponerror> EQ 1]
	(print,Timeout beim warten auf Eingang #<pvalue>)
	
	(dlgname,Timeout)
	(dlg,Timeout beim warten auf Wert #<qvalue> an Eingang #<pvalue>. Neu versuchen?, typ=label, x=0, w=410, color=0xffffff)
	(dlg,./Icons/Warning.png, typ=image, x=0)
	(dlg,|Ja|Nein, typ=checkbox, x=50, w=410, def=1, store, param=option)
	(dlgshow)
	o<opt> if [#<option> NE 1]
		#<_sx_canceled> = 1
		#<exit>=1
		M2
	o<opt> else
		#<exit>=0
	o<opt> endif
O<chk> endif

o<lpp> while [#<exit> EQ 0]