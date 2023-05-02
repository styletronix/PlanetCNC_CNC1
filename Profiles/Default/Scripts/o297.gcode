o297 ;Multi measure by MPG

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen

M73
G08 G15 G94 G91 G91.2

O<debug> if[#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif

M55 P0	;Transformations disabled
M56 P0	;Warp Disable
M57 P0	;Swap Disable
M10 P1	;Enable Motors

#<mode> = DEF[#<qvalue>,0]

o<modecheck> if [#<mode> LE 0]
	(dlgname,Messmodus auswählen)
	(dlg,M1 M2 und M3 müssen in der richtigen Reihenfolge verwendet werden., typ=label, x=0, w=600, color=0xffffff)
	(dlg,./img/probeM.png, typ=image, x=0)
	(dlg,Messmodus auswählen, typ=label, x=0, w=600, color=0xffffff)
	(dlg,|M1 Nut rechts|\M2 Nut links|\M3 linke Kante|\M4 Tiefe, typ=checkbox, x=10, w=140, def=0, store, param=mode)
	(dlgshow)
o<modecheck> endif


o<mode> if [#<mode> EQ 1]		;1 Find depth and Measure right slot
	(dlgname,Messung M1)
	(dlg,Suche tiefe und Messe rechte Nut in Y richtung., typ=label, x=0, w=600, color=0xffffff)
	
	(dlg,1. Der Messtaster fährz in Z- nach unten bis er Kontakt hat., typ=label, x=0, w=600, color=0xffffff)
	(dlg,2. Die Nut wird in Y Richtung vermessen., typ=label, x=0, w=600, color=0xffffff)
	(dlg,3. Der Messpunkt wird intern gespeichert und der Messtaster fährt aus der Nut heraus, typ=label, x=0, w=600, color=0xffffff)
	
	(dlg,./img/probe_slot_right.png, typ=image, x=0)
	(dlg,OK startet Messung, typ=label, x=0, w=600, color=0xff0000)
	
	(dlgshow)
	(print,|!|bMessung 1: Suche tiefe und Messe rechte Nut in Y richtung.)
	
	G65 P110 H2 E-1 R0 I0		;find height (Z-)
	G65 P160 H1					;Measure Slot in Y direction
	G91 G01 Z20					;Move relative Z+20
	
	;Store measure result P1
	#<_sx_297_p1_0> = #<_measure_axis|0>
	#<_sx_297_p1_1> = #<_measure_axis|1>
	

o<mode> elseif [#<mode> EQ 2]	;----- 2 find depth, Measure left slot and set offset ----
	(dlgname,Messung M2)
	(dlg,Suche tiefe und Messe linke Nut in Y richtung., typ=label, x=0, w=600, color=0xffffff)
	
	(dlg,1. Der Messtaster fährt in Z- nach unten bis er Kontakt hat., typ=label, x=0, w=600, color=0xffffff)
	(dlg,2. Die Nut wird in Y Richtung vermessen., typ=label, x=0, w=600, color=0xffffff)
	(dlg,3. Der Winkel zwischen M1 und M2 wird als Korrektur angewendet, typ=label, x=0, w=600, color=0xffffff)
	(dlg,4. Der Nullpunkt in Y wird in die Mitte der Nut gesetzt, typ=label, x=0, w=600, color=0xffffff)
		
	(dlg,./img/probe_slot_left.png, typ=image, x=0)
	(dlg,OK startet Messung, typ=label, x=0, w=600, color=0xff0000)
	(dlgshow)
	(print,|!|bMessung 2: Suche tiefe und Messe linke Nut in Y richtung.)
	
	G65 P110 H2 E-1 R0 I0		;find height (Z-)
	G65 P160 H1					;Measure Slot in Y direction
	G91 G01 Z20					;Move relative Z+20
	
	;Store measure result P2
	#<_sx_297_p2_0> = #<_measure_axis|0>
	#<_sx_297_p2_1> = #<_measure_axis|1>
	
	G65 P102 H1 J0 K0			;Calculate offset 
	$<cmd_setcsoffset>			;Set offset
	
	;Calculate and set rotation based on P1 and P2
	#<_measure_rot> = [atan2[[#<_sx_297_p1_1> - #<_sx_297_p2_1>],[#<_sx_297_p1_0> - #<_sx_297_p2_0>]]]
	G10 L2 P#<_coordsys> R#<_measure_rot>

o<mode> elseif [#<mode> EQ 3]	;----- 3 Measure left edge and set offset -----
	(dlgname,Messung M3)
	(dlg,Messe linke Kante der Nut, typ=label, x=0, w=600, color=0xffffff)
	
	(dlg,1. Der Messtaster fährt in Z- nach unten bis er kontakt hat., typ=label, x=0, w=600, color=0xffffff)
	(dlg,2. Die Kante der Nut wird in X- Richtung vermessen., typ=label, x=0, w=600, color=0xffffff)
	(dlg,3. Der Nullpunkt in X wird auf die Kante geetzt, typ=label, x=0, w=600, color=0xffffff)
	
	(dlg,./img/probe_left.png, typ=image, x=0)
	(dlg,OK startet Messung, typ=label, x=0, w=600, color=0xff0000)
	(dlgshow)
	(print,|!|bMessung 3: Messe linke Kante der Nut)
	
	G65 P110 H2 E-1 R0 I0		;find height (Z-)
	
	G65 P110 H0 E-1 R0			;Measure in X- direction
	G65 P102 H0 J0				;Calculate offset 
	G91 G01 Z20					;Move relative Z+20
	
	$<cmd_setcsoffset>			;Set offset

o<mode> elseif [#<mode> EQ 4]
	(dlgname,Messung M4)
	(dlg,Messe Tiefe, typ=label, x=0, w=600, color=0xffffff)	
	(dlg,1. Der Messtaster fährt in Z- nach unten bis er kontakt hat., typ=label, x=0, w=600, color=0xffffff)
	(dlg,2. Der Punkt wird als Nullpunkt in Z gesetzt, typ=label, x=0, w=600, color=0xffffff)
	(dlg,OK startet Messung, typ=label, x=0, w=600, color=0xff0000)
	(dlgshow)
	
	(print,|!|bMessung 4: Messe Tiefe)
	
	G65 P121 R1
	G91 G01 Z20
	
o<mode> else
	(msg,Unbekannte auswahl)
	#<_sx_canceled> = 1
	M2
o<mode> endif


M99