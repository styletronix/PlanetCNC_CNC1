; 2022-06-05	Optimize Movement and add Comments
; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen
M104  ;Sichere Startposition


G01 X0 Y0 F#<_speed_traverse>