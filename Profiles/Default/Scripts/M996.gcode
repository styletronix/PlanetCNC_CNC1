; 2023-08-08    First implementation

;P...
;   1   Spindel kann bei Sonde nicht aktiviert werden.
;           Abbruch

;   2   OK / Abbruch    Spindel starten?
;           OK / Abbruch

;   3   Werkzeuglänge jetzt messen?
;           _result 1 = Ja / 2 = Nein


#<dlgNum> = def[#<pvalue>,0];


o<chk> if [EQ[#<dlgNum>,1]]
    (dlgname,'Ungültige Aktion', bok=0, bcancel=1, bw=150, bh=40)
	(dlg,./img/dlg_border_blue.png, typ=image, x=0, y=0)
	(dlg,./img/dlg_head_invalid.png, typ=image, x=200, y=30)
	(dlg,./img/dlg_sign_Warning.png, typ=image, x=10, y=20)
	(dlg,./img/dlg_txt_probeNoSpindle.png, typ=image, x=200, y=120)
	(dlg, 'Wechseln Sie zu einem anderen Werkzeug um die Spindel zu aktivieren.', typ=label, x=200, y=300, color=0xfffffff)
	(dlg,./img/dlg_button_Cancel.png, typ=image, x=400, y=350)
	(dlgshow)
    #<_sx_canceled> = 1
    M02

o<chk> elseif [EQ[#<dlgNum>,2]]
    (dlgname,'Spindel starten?'', bok=1, bcancel=1, bw=150, bh=40)
	(dlg,./img/dlg_border_yellow.png, typ=image, x=0, y=0)
	(dlg,./img/dlg_head_startAction.png, typ=image, x=200, y=30)
	(dlg,./img/dlg_sign_start.png, typ=image, x=20, y=20)
	(dlg,./img/dlg_txt_startSpindle.png, typ=image, x=200, y=120)
	(dlg,./img/dlg_button_OkCancel.png, typ=image, x=400, y=350)
	(dlgshow)

o<chk> elseif [EQ[#<dlgNum>,3]]
    (dlgname,'Werkzeuglänge jetzt messen?'', bok=1, bcancel=1, bw=150, bh=40)
    (dlg,./img/dlg_border_green.png, typ=image, x=0, y=0)
    (dlg,./Icons/IMG_MeasureTool.svg, typ=image, w=256, x=10, y=20)
    (dlg,'Werkzeuglänge wurde nicht gemessen.', typ=label, x=200, y=30, color=0xffffff)
	(dlg,'Jetzt messen?', typ=label, x=200, y=120, color=0xffffff)
	(dlg,|Ja|\Nein - ohne Messung fortsetzen, typ=checkbox, x=200, def=1, param=opttool)
	(dlgshow)
    #<_return> = #<opttool>

o<chk> elseif
    (dlgname,'Interner Fehler, bok=0, bcancel=1, bw=150, bh=40)
	(dlg,./img/dlg_border_red.png, typ=image, x=0, y=0)
	(dlg,./img/dlg_head_error.png, typ=image, x=200, y=30)
	(dlg,./img/dlg_sign_error.png, typ=image, x=10, y=20)
	(dlg,'Der Meldungstext wurde nicht gefunden.', typ=label, x=200, y=120, color=0xfffffff)
    (dlg,'Aus Sicherheitsgründen wird abgebrochen.', typ=label, x=200, color=0xfffffff)
	(dlg,./img/dlg_button_Cancel.png, typ=image, x=400, y=350)
	(dlgshow)
    #<_sx_canceled> = 1
    M02

o<chk> endif