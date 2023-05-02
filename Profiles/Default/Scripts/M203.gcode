;M203	Temperaturparameter einstellen

; 2023-02-18 Erste Einrichtung


#<pmax> = [#<_sx_tool_temperature_max> / #<_sx_tool_temperature_celcius_factor>]
#<pcritical> = [#<_sx_tool_temperature_critical> / #<_sx_tool_temperature_celcius_factor>]

(dlgname,Temperaturüberwachung)
(dlg,Pause ab , x=0, dec=0, def=pmax, min=30, max=140, setunits, param=pmax)
(dlg,Not-Stop ab , x=0, dec=0, def=pcritical, min=30, max=140, setunits, param=pcritical)
(dlgshow)


#<_sx_tool_temperature_max> = [#<pmax> * #<_sx_tool_temperature_celcius_factor>]
#<_sx_tool_temperature_critical> = [#<pcritical> * #<_sx_tool_temperature_celcius_factor>]
