(name,Measure Tool Length)

; 2022-06-06	Startbedingungen prüfen

M999	;Startbedingungen prüfen
M104  ;Sichere Startposition

o<MeasureToolLength> call
M2