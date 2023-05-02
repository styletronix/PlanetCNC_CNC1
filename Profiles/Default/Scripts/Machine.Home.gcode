(name, Home)

M73
G17 G90 G91.1 G90.2 G08 G15 G94

O<debug> if [#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif

M55 P0
M56 P0
M57 P0
M10 P1
M11 P0		;Hard-Limit off
M11 P10		;Soft-Limit off

#<main> = 0

(print,|!|bReferenzfahrt gestartet)

o<wirelessProbe> if [DEF[#<_sx_wireless_probe_in>,0] GT 0]
	#<_probe_pin_2> = 0
	G9
o<wirelessProbe> endif

o<CheckProbe1> if [DEF[#<_probe_pin_1>,0] GT 0]
	o<CheckProbe1b> if [#<_hw_input_num|#<_probe_pin_1>> NE 0]
		(print,     Werkzeuglängensensor ist aktiv. Sensor prüfen und erneut versuchen.)
        (msg,Werkzeuglängensensor ist aktiv. Sensor prüfen und erneut versuchen.)
		#<_sx_canceled> = 1
		M2
	o<CheckProbe1b> endif
o<CheckProbe1> endif

o<CheckProbe2> if [DEF[#<_probe_pin_2>,0] GT 0]
	o<CheckProbe2b> if [#<_hw_input_num|#<_probe_pin_2>> NE 0]
		(print,     Kantentaster ist aktiv. Sensor prüfen und erneut versuchen.)
        (msg,Kantentaster ist aktiv. Sensor prüfen und erneut versuchen.)
		#<_sx_canceled> = 1
		M2
	o<CheckProbe2b> endif
o<CheckProbe2> endif

o<mainloop> while [#<main> LT 9]
  #<axis>=0
  o<axisloop> while [#<axis> LT 9]
    #<order> = [#<_home_order_axis|#<axis>> - 1]
    o<ord> if [#<order> EQ #<main>]

      #<dir> = 0
      #<pin> = 0
      o<dir> if [#<_home_dir_axis|#<axis>> GT +0.5]
        #<dir> = +1
        #<pin> = #<_limitpin_p_axis|#<axis>>
      o<dir> elseif [#<_home_dir_axis|#<axis>> LT -0.5]
        #<dir> = -1
        #<pin> = #<_limitpin_n_axis|#<axis>>
      o<dir> endif

      o<checkdir> if [#<dir> EQ 0]
		(print,     Richtung für Achse $<axis|#<axis>> fehlt)
        (msg, Richtung für Achse $<axis|#<axis>> fehlt)
		#<_sx_canceled> = 1
        M2
      o<checkdir> endif

      o<checkpin> if [#<pin> EQ 0]
		(print,     Referenzschalter ist nicht konfiguriert)
        (msg, Referenzschalter ist nicht konfiguriert)
		#<_sx_canceled> = 1
        M2
      o<checkpin> endif

      ;--------------------------------------------
      o<probehome> call [#<axis>] [#<dir>] [#<pin>]
      ;--------------------------------------------

    o<ord> endif
    #<axis> = [#<axis> + 1]
  o<axisloop> endwhile
  #<main> = [#<main> + 1]
o<mainloop> endwhile

M11 P1		;Hard-Limit an
M11 P11		;Soft-Limit an
#<_sx_machine_home_required> = 0
#<_sx_canceled> = 1

(print,|!|bReferenzfahrt beendet)
M2


o<probehome> sub
	M73
	O<debug> if [#<_sx_debug> EQ 0]
		M50 P0		;Disable Override Feed
	O<debug> endif
	M11 P0			;Hard-Limit off

	#<axis> = #1
	#<dir> = #2
	#<pin> = #3
	
	(print,   Referenzfahrt Achse $<axis|#<axis>>)
	
	o<issim> if [#<_hw_sim> EQ 1]
		(print,    Simulation! Endschalter wird ignoriert!)

		(txt,cmd_move,G53 G01 $<axis|#<axis>>#<_home_swpos_axis|#<axis>> F#<_home_speed>)
		G9
		$<cmd_move>
		
		G04 P0.2
		
		(txt,cmd_move,G91 G91.2 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>] F#<_home_speed>)
		G9
		$<cmd_move>
		
		#<diff> = 0
	o<issim> else
		
	o<chk> if [#<_hw_limit_num|#<pin>> NE 0]
			(print,     WARNUNG: Schalter bereits aktiv. Freifahren in Gegenrichtung...)
			G91 G91.2 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>] F#<_home_speed>
			G9
			o<chk2> if [#<_hw_limit_num|#<pin>> NE 0]
				(print,     FEHLER bei Referenzfahrt: Schalter bereits aktiv)
				(msg, FEHLER bei Referenzfahrt: Schalter bereits aktiv. Endschalter Prüfen.)
				#<_sx_canceled> = 1
				M2
			o<chk2> endif
	o<chk> endif
  
	o<low> if [#<_home_speed_low> GT 0]
		o<mode> if [#<_sx_useFastFind>]
			(debug, - _sx_useFastFind)
			G53 G65 P201 H#<axis> E#<dir> R#<pin> Q0 D3000 F#<_home_speed> M#<_home_swdist>
			G04 P0.2
			o<chk> if [def[#<_return>,0] NE 1]
				(print,     Fehler bei Referenzfahrt: Schalter nicht gefunden)
				(msg, Fehler bei Referenzfahrt: Schalter nicht gefunden)
				#<_sx_canceled> = 1
				M2
			o<chk> endif
		o<mode> else
			(debug, - _home_speed)
			(debug,     Suche Endschalter mit hoher Geschwindigkeit... )
			G53 G38.1 H#<axis> E#<dir> F#<_home_speed>
			G9
			
			;Check if Limit switch was reached --------------------
			o<chk> if [[#<_probe> NE 1] OR [#<_hw_limit_num|#<pin>> NE 1]]
				(print,     FEHLER Der Endschalter wurde nicht gefunden. )
				(msg, FEHLER Der Endschalter wurde nicht gefunden. Endschalter und Motor auf Funktion prüfen. )
				#<_sx_canceled> = 1
				M2
			o<chk> endif
			G04 P0.2
			
			G91 G91.2 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>] F#<_home_speed>			
		o<mode> endif
		
		(debug,     Suche Endschalter mit niedriger Geschwindigkeit... )
		G90 G90.2 G53 G38.1 H#<axis> E#<dir> F#<_home_speed_low>
		G9
		o<chk> if [[#<_probe> NE 1] OR [#<_hw_limit_num|#<pin>> NE 1]]
			(print,     FEHLER Der Endschalter wurde nicht gefunden. )
			(msg, FEHLER Der Endschalter wurde nicht gefunden. Endschalter und Motor auf Funktion prüfen. )
			#<_sx_canceled> = 1
			M2
		o<chk> endif
			
		#<diff> = [#<_home_swpos_axis|#<axis>> - #<_machine_axis|#<axis>>]			
	o<low> else
		(debug,     Suche Endschalter... )
		G53 G38.1 H#<axis> E#<dir> F#<_home_speed>
		o<chk> if [[#<_probe> NE 1] OR [#<_hw_limit_num|#<pin>> NE 1]]
			(print,     FEHLER Der Endschalter wurde nicht gefunden. )
			(msg, FEHLER Der Endschalter wurde nicht gefunden. Endschalter und Motor auf Funktion prüfen. )
			#<_sx_canceled> = 1
			M2
		o<chk> endif
		
		(debug, Probe pos: #<_probe_axis|#<axis>>  /  #<_home_swpos_axis|#<axis>>  /  #<_machine_axis|#<axis>>)
		#<diff> = [#<_home_swpos_axis|#<axis>> - #<_machine_axis|#<axis>>]
	o<low> endif

	;(print,|!     Differenz $<axis|#<axis>>  #<diff>)
	G10 L9 H#<axis> E[#<_home_swpos_axis|#<axis>>]
		
	G04 P0.2
		

	o<issim> endif
	
	M11 P1 		;Hard-Limit on
	G90 G90.2
	
	o<chk> if [[[#<_home_moveto_axis|#<axis>>] EQ 0 ] And [#<axis> EQ 2]]
		(print,|b     Fahrt auf Z0.0 nach Referenzfahrt ist aus sicherheitsgründen gesperrt. )
		#<_sx_canceled> = 1
		M2
	o<chk> else
		(print,    Fahre auf Stop-Position #<_home_moveto_axis|#<axis>>)
		G53 G00 H#<axis> E[#<_home_moveto_axis|#<axis>>]
	o<chk> endif	
	
	(print,|!    Referenzfahrt Achse $<axis|#<axis>> mit Differenz #<diff> beendet)
o<probehome> endsub

