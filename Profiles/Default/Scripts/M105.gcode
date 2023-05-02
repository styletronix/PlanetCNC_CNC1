; WKZ Bruchkontrolle
; 2022-06-01	update

M102		;Flight height
M5			;Spindel aus
M9			;Kühlung aus
M101 Q0		;Schwenkantrieb Öl aus
M100 Q0		;Niederhalter aus

G65 P122 U0 R3

M104		;Move to safe position

