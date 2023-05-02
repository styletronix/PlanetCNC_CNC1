;Berechnung des mittelwerts für Nullpunkt verschiebung von Messpunkten

#<mode> = [#<pvalue>]
#<positionDifference> = [DEF[#<qvalue>,0]]

;P-1	Reset
;P0 Add X Point
;P1 Add Y Point
;P2 Add Z Point
;P3 Add Rotation
;P4 GetResult


o<mode> if [#<mode> EQ -1]
	#<_sx_measure_Normalize_Sum_0> = 0
	#<_sx_measure_Normalize_Sum_1> = 0
	#<_sx_measure_Normalize_Sum_2> = 0
	#<_sx_measure_Normalize_Sum_r> = 0
	#<_sx_measure_Normalize_Count_0> = 0
	#<_sx_measure_Normalize_Count_1> = 0
	#<_sx_measure_Normalize_Count_2> = 0
	#<_sx_measure_Normalize_Count_r> = 0
o<mode> elseif [#<mode> EQ 0]
	#<_sx_measure_Normalize_Count_0> = [#<_sx_measure_Normalize_Count_0> + 1]
	#<_sx_measure_Normalize_Sum_0> = [#<_sx_measure_Normalize_Sum_0> + #<positionDifference>]
o<mode> elseif [#<mode> EQ 1]
	#<_sx_measure_Normalize_Count_1> = [#<_sx_measure_Normalize_Count_1> + 1]
	#<_sx_measure_Normalize_Sum_1> = [#<_sx_measure_Normalize_Sum_1> + #<positionDifference>]
o<mode> elseif [#<mode> EQ 2]
	#<_sx_measure_Normalize_Count_2> = [#<_sx_measure_Normalize_Count_2> + 1]
	#<_sx_measure_Normalize_Sum_2> = [#<_sx_measure_Normalize_Sum_2> + #<positionDifference>]
o<mode> elseif [#<mode> EQ 3]
	#<_sx_measure_Normalize_Count_r> = [#<_sx_measure_Normalize_Count_r> + 1]
	#<_sx_measure_Normalize_Sum_r> = [#<_sx_measure_Normalize_Sum_r> + #<positionDifference>]
o<mode> elseif [#<mode> EQ 4]
	#<x> = [#<_sx_measure_Normalize_Sum_0> / Max[#<_sx_measure_Normalize_Count_0>,1]]
	#<y> = [#<_sx_measure_Normalize_Sum_1> / Max[#<_sx_measure_Normalize_Count_1>,1]]
	#<z> = [#<_sx_measure_Normalize_Sum_2> / Max[#<_sx_measure_Normalize_Count_2>,1]]
	#<r> = [#<_sx_measure_Normalize_Sum_r> / Max[#<_sx_measure_Normalize_Count_r>,1]]
	
	(print,X#<x> Y#<y> Z#<z> R#<r> )
o<mode> endif



M99