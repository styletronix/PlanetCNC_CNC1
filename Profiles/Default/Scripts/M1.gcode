(name,Optionale Pause)

;Changes	
; 2022-02-24	removed: use _sx_pause_optional for optional pause, because optional pause enabled state is currently not accessible in scripts
; 2022-03-07	use _pause_optional for optional pause ´requires beta of tngv2 2022-03-07
; 2022-06-01	German localization
; 2022-06-26	Rücksetzen der optionalen Pause nach M0

o<chk> if [#<_pause_optional> EQ 1]
	(print,|! Optionale Pause aktiv)
	M0
	(print,Optionale Pause ende)
o<chk> endif