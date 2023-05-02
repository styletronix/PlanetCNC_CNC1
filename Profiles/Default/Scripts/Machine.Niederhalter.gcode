o<dwn> if [ #<_hw_output_num|#<_sx_niederhalter_pin>> NE 1 ]
	M62 P#<_sx_niederhalter_pin> Q0
o<dwn> else
	M62 P#<_sx_niederhalter_pin> Q1
o<dwn> endif