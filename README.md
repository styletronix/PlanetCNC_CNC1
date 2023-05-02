# PlanetCNC_CNC1
Profile for Planet CNC TNGv2



T0 M6	Tool Change	(Verwende T#<_toolnumber> M6 

M0		Pause

M1		Optionale Pause

M3		Spindelstart CW

M4		Spindelstart CCW

M5		Spindel stop

M6		Tool change

M100	Niederhalter
	--	Aus / An
	Q0 	Aus
	Q1 	An
	
M101	Ölschlauch
	--	An / Aus
	Q0 Aus
	Q1 An
	
M102	Move to Flight height

M103	Warte auf Eingang
	P<Eingang> 
	Q<Warte auf Ein(1) oder Aus(0)> 
	R<Timeout in Sekunden>
	
M104	Zu sicherer Startposition fahren

M105	Werkzeugbruchkontrolle

M106	Zu Maschinen-Parkposition fahren

M107	Werkzeuglänge messen
	-> o122

M110 
	P0	Funk Taster ein
	P1	Warte auf Funk Taster bereitschaft
	P2	Prüfe auf Fehler (nach Messung)
	P3	Funk-Taster aus.
	P4	Funk-Taster ein/aus.
	P5	Funk-Taster ein/aus wenn Tool = Probe
	P6	Stop bei kontakt
	P7	Deaktivieren ohne ausschalten (Gegensatz zu P6)

M111	in bearbeitung

M112	WKZ Wechsel und Parken
	P<WKZ Nr.>

M114	Manuell reinigen.

M115	Automatische Reinigung
	X	Bereich X
	Y	Bereich Y
	I	Bereich X
	J	Bereich Y
	Z	Flughöhe
	K	Schrittweite

M200	Messe Nut
	?????????
	
M201	setcsoffset
	H	Achse (nicht bei Q1)
	Q1	Wahlschalter von MPG verwenden

M202	Dialog für Bereichsauswahl anzeigen

M203	Dialog für Temperaturüberwachung anzeigen.

M204	Dialog für Koordinatensystem bearbeiten

M262	Ausgang schalten
	Q	0 Aus / 1 An.
	P	1-8 Intern / 101-116 ExtOut1 / 201-216 ExtOut2.

M300	Spindel start / stop mit Warnung
	Q0	CW	/ an aus
	Q1	CCW / an aus

M999	Startbedingungen prüfen (z.b. referenzfahrt / Störung)

M30		Programm ende

M11		
	P	10 Soft-Limit aus
		11 Soft-Limit an
		0	Hard-Limit aus
		1	Hard-Limit an


G65 P135 ....
o102	Offset calculation
		Nach Messung für XY die Befehle cmd_setworkoffset, cmd_setcsoffset, cmd_movetoZero und cmd_moveto erstellen.
	H*	Gemessene Achse 0=X / 1=Y / 2=Z
	J*	Erwartetes Workoffset in Messrichtung (H)
	K	Erwartetes Workoffset quer zur Messrichtung
	
o103	Nach Messung für XY die Befehle cmd_setworkoffset, cmd_setcsoffset und cmd_moveto erstellen.
	J*	Erwartete Position X
	K*	Erwartete Position Y
HINWEIS: Wurde durch o102 ersetzt !!

o109 	Probe Check
	Prüfe ob Sonde bereit ist

o110	Probing
	Q*	0	WKZ Sensor
		1	Messtaster
	H*	Messachse 0=X / 1=Y / 2=Z
	E*	Messrichtung 1 / -1
	D	Maximale Strecke bis Kontakt
	K	Rückzug nach Messung
	F	Vorschub
	I	langsamer Vorschub
	R	Rückkehr zu Startposition

o121 	Measure Coordinate System Offset

o122 	Werkzeuglänge messen
	U	Zurück zu Startposition 1*=Ja / 0=Nein
	Q	Werkzeugnummer. Standard: _current_tool
	R	1=Setzen mit G43.1 Z#<off>
		2=WKZ Länge setzen mit G10 L1 P#<num> Z#<off>
		3=WKZ Bruchkontrolle
		Standard: #<_tc_toolmeasure>
	V	Differenz für WKZ Bruchkontrolle R3 (Standard: 0.1)
G65 P122 U0 R3


o131 	Measure Edge Find

o135 	Messe Winkel
	D*		Distanz zwischen Messpunkten
	H*		Achse 0-2
	E*		Richtung (-1 oder 1)
	J 		Tolleranz min-Wert  (M2 wenn außer tolleranz)
	K		Tolleranz max-Wert	(M2 wenn außer tolleranz)
	
o150 	Measure Hole

o160 	Measure Slot

o165 	Measure Tab

o201 	Find switch

o202 	Measure Rectangle

o203	Set Z Limit by Tool offset

o204	probing-xy-circular-boss

o205 	probing-wall

o206 	Request Tool Changed

o297 	Multi measure by MPG
	Q*	0	Auswahldialog
		1	Nut rechts			Nur messung und wert speichern. Wird erst nach Messung 2 zur Rotation verwendet.
		2	Nut links			1 + 2 = WCS wird rotiert damit Messung 1 und 2 linear zu X verläuft 
		3	Links				linker anschlag
		4	Tiefe				Höhe

o298	Change CoordSystem by MPG
	#<_hw_mpg_custom>

o299	Change Tool by MPG
	#<_hw_mpg_custom>
	
o300	Parameter ausgeben

G65 P121 ....
o121 ;Measure Coordinate System Z
	(D)		Maximaler Messweg. Bei überschreitung wird abgebrochen.
	(R)		Rückkehr zum ausgangspunkt nach Messung = R1
	(Z)		Offset zum Arbeits-Nullpunkt





;Parameter {"clearance":155,"retract":5,"depth":7,"feedrate":500,"retractFeedrate":500,"probeClearance":20,"probeOvertravel":50,"probeMode":0,"approach1":"positive","probeSpacing":67,"probeOrientation":0.141897052526474,"nominalAngle":8.130102157592773,"hasPositionalTolerance":0,"hasSizeTolerance":0,"hasAngleTolerance":1,"toleranceAngle":1,"updateToolWear":0,"printResults":0,"stock":5,"bottom":-2,"plungeFeedrate":500,"dwell":0,"incrementalDepth":7,"incrementalDepthReduction":0,"minimumIncrementalDepth":0,"plungesPerRetract":1,"shift":0,"shiftOrientation":0,"compensatedShiftOrientation":0,"shiftDirection":3.141592653589793,"backBoreDistance":0,"stopSpindle":0}
;Erwarteter Messwert 8.130102157592773

probeOvertravel + probeClearance

"hasAngleTolerance":1,"toleranceAngle":1

G65 P235 H1 E1 D[probeSpacing]	-> Messen
G65 P300 Q[min] R[max]		-> Prüfe Rotation



https://www.cnczone.com/forums/planetcnc/403208-independent-pwm-signal-output-3.html