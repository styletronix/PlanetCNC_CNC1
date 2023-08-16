; 2023-08-08    First implementation

;P...
;   1   Spindel kann bei Sonde nicht aktiviert werden.
;           Abbruch
;   2   OK / Abbruch    Spindel starten?
;           OK / Abbruch
;   3   Werkzeuglänge jetzt messen?
;           _result 1 = Ja / 2 = Nein
;	4	Temp Warnung. Temp. bearbeite?
;			 _result 1 = Ja / 2 = Nein
;	5 	Optionale Pause beenden?
;			_result 1 = Ja / 2 = Nein
;	6	Temperatur einstellen.

#<dlgNum> = def[#<pvalue>,0]


o<chk> if  [#<dlgNum> EQ 1]
    (dlgname,'Ungültige Aktion', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_blue.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_invalid.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_Warning.png', typ=image, x=10, y=20)
	(dlg,'./img/dlg_txt_probeNoSpindle.png', typ=image, x=200, y=120)
	(dlg, 'Wechseln Sie zu einem anderen Werkzeug um die Spindel zu aktivieren.', typ=label, x=200, y=300, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
    #<_sx_canceled> = 1
    M02

o<chk> elseif [#<dlgNum> EQ 2]
    (dlgname,'Spindel starten?', bok=1, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_yellow.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_startAction.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_start.png', typ=image, x=20, y=20)
	(dlg,'./img/dlg_txt_startSpindle.png', typ=image, x=200, y=120)
	(dlg,'./img/dlg_button_OkCancel.png', typ=image, x=400, y=350)
	(dlgshow)
	M99

o<chk> elseif [#<dlgNum> EQ 3]
    (dlgname,'Werkzeuglänge jetzt messen?', bok=1, bcancel=1, bw=150, bh=40)
    (dlg,./img/dlg_border_green.png, typ=image, x=0, y=0)
    (dlg,./Icons/IMG_MeasureTool.png, typ=image, w=256, x=10, y=20)
    (dlg,'Werkzeuglänge wurde nicht gemessen.', typ=label, x=200, y=30, color=0xffffff)
	(dlg,'Jetzt messen?', typ=label, x=200, y=120, color=0xffffff)
	(dlg,|Ja|\Nein - ohne Messung fortsetzen, typ=checkbox, x=200, w=400 def=1, param=opttool)
	(dlg,'./img/dlg_button_OkCancel.png', typ=image, x=400, y=350)
	(dlgshow)
    #<_return> = #<opttool>
	M99

o<chk> elseif [#<dlgNum> EQ 4]
	(dlgname,'zu hohe Temperatur', bok=1, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_yellow.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_sign_Warning.png', typ=image, x=10, y=20)
	(dlg,'Pause wegen zu hoher Temperatur.', typ=label, x=200, y=30, color=0xffffff)
	(dlg,'Temperatureinstellung anpassen?', typ=label, x=200, y=120, color=0xffffff)
	(dlg,|Ja|\Nein - ohne Änderung fortsetzen, typ=checkbox, x=200, w=400, def=2, param=settemp)
	(dlg,'./img/dlg_button_OkCancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_return> = #<settemp>
	M99

o<chk> elseif [#<dlgNum> EQ 5]
	(dlgname,'Pause', bok=1, bcancel=1, bw=150, bh=40)
    (dlg,./img/dlg_border_green.png, typ=image, x=0, y=0)
	(dlg,'./Icons/IMG_Pause.png', typ=image, x=10, y=20, w=256)
	(dlg,'Optionale Pause aktiv.', typ=label, x=200, y=30)
	(dlg,'Optionale Pause beenden?', typ=label, x=200, y=120)
	(dlg,|Ja - Fortsetzen und NICHT am nächsten Punkt halten.|\Nein - Fortsetzen und an nächstem Pausepunkt halten., typ=checkbox, x=200, w=400, def=1, param=optpause)
	(dlg,'./img/dlg_button_OkCancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_return> = #<optpause>
	M99

o<chk> elseif [#<dlgNum> EQ 6]
	M203

o<chk> elseif [#<dlgNum> EQ 7]
    (dlgname,'Programm starten?', bok=1, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_yellow.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_startAction.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_start.png', typ=image, x=20, y=20)
	(dlg,'Programm starten?', typ=label, x=200, y=120, color=0xfffffff)
	(dlg,'./img/dlg_button_OkCancel.png', typ=image, x=400, y=350)
	(dlgshow)
	M99

o<chk> elseif [#<dlgNum> EQ 8]
	(dlgname,'Referenzfahrt erforderlich', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_red.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_error.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_error.png', typ=image, x=10, y=20)
	(dlg,'Referenzfahrt erforderlich.', typ=label, x=200, y=120, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_sx_canceled> = 1
	M02

o<chk> elseif [#<dlgNum> EQ 9]
	(dlgname,'Störung vorhanden', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_red.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_error.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_error.png', typ=image, x=10, y=20)
	(dlg,'Störungen zuerst quittieren.', typ=label, x=200, y=120, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_sx_canceled> = 1
	M02

o<chk> elseif [#<dlgNum> EQ 10]
	(dlgname,'Störung', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_red.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_error.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_error.png', typ=image, x=10, y=20)
	(dlg,'Es ist kein Werkzeug in der Spannzange enthalten obwohl dieses angegeben wurde.', typ=label, x=200, y=120, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_sx_canceled> = 1
	M02

o<chk> elseif [#<dlgNum> EQ 11]
	(dlgname,'Störung', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_red.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_error.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_error.png', typ=image, x=10, y=20)
	(dlg,'Es ist ein Werkzeug in der Spannzange enthalten obwohl keines angegeben wurde.', typ=label, x=200, y=120, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_sx_canceled> = 1
	M02

o<chk> elseif [#<dlgNum> EQ 12]
	(dlgname,'Störung', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_red.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_error.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_error.png', typ=image, x=10, y=20)
	(dlg,'Werkzeugversatz ist nicht aktiv.', typ=label, x=200, y=120, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
	#<_sx_canceled> = 1
	M02

o<chk> else
    (dlgname,'Interner Fehler', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,'./img/dlg_border_red.png', typ=image, x=0, y=0)
	(dlg,'./img/dlg_head_error.png', typ=image, x=200, y=30)
	(dlg,'./img/dlg_sign_error.png', typ=image, x=10, y=20)
	(dlg,'Der Meldungstext wurde nicht gefunden.', typ=label, x=200, y=120, color=0xfffffff)
    (dlg,'Aus Sicherheitsgründen wird abgebrochen.', typ=label, x=200, color=0xfffffff)
	(dlg,'./img/dlg_button_Cancel.png', typ=image, x=400, y=350)
	(dlgshow)
    #<_sx_canceled> = 1
    M02

o<chk> endif