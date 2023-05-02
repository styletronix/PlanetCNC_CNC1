(dlgname,Test, opt=1)
(dlg,Text, typ=label, x=0, w=410, color=0xffffff)

(dlg,Eingabefeld, dec=3, def=-20, min=-1000, max=1000, param=length)	
(dlg,Eingabefeld, x=0, dec=2, def='setunit(20, 1);', min=0.1, max=10000, setunits, store, param=dist)

(dlg,|Ja|Nein, typ=checkbox, x=50, w=600, def=1, store, param=option)
(dlg,checkbox, typ=checkbox, x=50, w=600, def=1, store, param=option)
(dlg,|Nut rechts|Nut links|linke Kante, typ=checkbox, x=10, w=150, def=0, store, param=mode)

(dlg,data::MeasureAngle, typ=image, x=0)
(dlg,./Icons/Warning.png, typ=image, x=0)

(dlgshow)