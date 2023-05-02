o110	;Probing
; 2022-02-15	Changed movement relative to wcs to respect rotation while probing
; 2022-02-18	Added cs and axis rotation
; 2022-02-22	Fixed: Tool size in wrong direction
; 2022-02-27	Fixed: Tool offst in wrong direction
; 2022-06-06	Startbedingungen prüfen
; 2023-02-08	Documentation for Parameters added

;Required
;Q 1=IsProbe 0=Tool length or homing
;H Axis num for measurement
;E Direction for Axis 1 / -1

;Optional
;D max distance for measurement before stopping
;K Return distance from mesure point in reverse direction
;F measure speed high / default from params
;I measure speed low / default from params  / 0=no low speed 
;J Offset Messtaster. (verwendet WKZ bibliothek wenn leer)


M999	;Startbedingungen prüfen

;TODO
;2022-02-19
(print,|!|bToDo: Check if Tool Offset works as expected)
(print,|!|bToDo: implement soft probing search o201)
(print,|!|bToDo: implement reverse measurement)

#<_return> = NAN[]
#<_measure> = 0
#<_measure_x> = NAN[]
#<_measure_y> = NAN[]
#<_measure_z> = NAN[]
#<_measure_sizex> = NAN[]
#<_measure_sizey> = NAN[]
#<_measure_sizez> = NAN[]
#<_measure_rot> = NAN[]

o<chk> if[LNOT[ACTIVE[]]]
  M99
o<chk> endif



#<isProbe> = [DEF[#<qvalue>, 1]]
#<axis> = #<hvalue>
#<dir> = #<evalue>
#<dist> = [DEFNZ[#<dvalue>,200]]
#<back> = [DEF[#<kvalue>,#<_probe_swdist>]]
#<speed> = [DEF[#<fvalue>,#<_probe_speed>]]
#<speedlow> = [DEF[#<ivalue>,#<_probe_speed_low>]]
#<returnToStart> = [DEF[#<rvalue>,0]]


;BEGIN Check Pre-Condition --------------------------------------------------
G65 P109 Q#<isProbe>

o<chk> if [NOTEXISTS[#<_return>]]
  (msg,Probe error: Probe)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [NOTEXISTS[#<axis>]]
  (msg,Axis value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [[#<axis> LT 0] OR [#<axis> GT 2]]
  (msg,Axis value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [NOTEXISTS[#<dir>]]
  (msg,Direction value missing)
  #<_sx_canceled> = 1
  M2
o<chk> endif
o<chk> if [[#<dir> EQ -1] XNOR [#<dir> EQ 1]]
  (msg,Direction value incorrect)
  #<_sx_canceled> = 1
  M2
o<chk> endif
;END Check Pre-Condition --------------------------------------------------

M73
G08 G15 G94 G91 G91.2

O<debug> if [#<_sx_debug> EQ 0]
	M50 P0		;Disable Override Feed
O<debug> endif
M55 P0	;Transformation disabled
M56 P0	;Warp disabled
M57 P0	;Swap disabled
M10 P1	;Motor enabled


o<chk> if [NOTEXISTS[#<dvalue>] AND [#<axis> EQ 2] AND [#<dir> EQ -1]]
  #<dist> = DEFNZ[#<_probe_length>, #<dist>]
o<chk> endif
o<chk> if [EXISTS[#<jvalue>]]
  #<size> = #<jvalue>
  #<off> = 0
o<chk> else
  #<size> = #<_probe_size_axis|#<axis>>
  #<off> = #<_tooloff_axis|#<axis>>
o<chk> endif

#<start_x> = #<_machine_x>
#<start_y> = #<_machine_y>
#<start_z> = #<_machine_z>
#<start> = #<_work_axis|#<axis>>

M110 P1 Q#<isProbe>			;Waiting for Probe ready...
M110 P6 Q#<isProbe>			;Probe stop on unexpected contact

;TODO: Soft Probing ---------------------------  TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
G38.2 H#<axis> E[#<dir> * #<dist>] F#<speed>
M110 P2 Q#<isProbe>			;Check if result is valid
G04 P0.08					;Prevent hard direction return

o<low> if[#<speedlow> GT 0]
	;G38.5  TODO: Reverse measurement --------  TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
	G01 H#<axis> E[-#<dir> * Min[#<back>, Abs[#<_work_axis|#<axis>> - #<start>] ]] F#<speed> 

	G38.2 H#<axis> E[#<dir> * #<dist>] F#<speedlow>
	M110 P2 Q#<isProbe>		;Check if result is valid
	G04 P0.08 				;Prevent hard direction return by adding delay
o<low> endif

M110 P7 Q#<isProbe>			;Disable probe monitoring
o<ret> if [#<returnToStart> GT 0]
	G90 G53 G01 X#<start_x> Y#<start_y> Z#<start_z> F#<_speed_traverse>
o<ret> else
	G01 H#<axis> E[-#<dir> * Min[#<back>, Abs[#<_work_axis|#<axis>> - #<start>] ]] F#<speed> 
o<ret> endif

;BEGIN Calculate Tool Offset -----------------------------------------------------------------------------------
;Rotate measure point and shift it to macht work cs for rotated probing
#<diff> = [#<dir> * #<size>]
#<machine_rot> = [#<_coordsys_rot> + #<_axisrot_ang>]

o<axnum> if [#<axis> EQ 0]
	#<_measure_axis|0> = [#<_probe_axis|0> - #<off> + #<diff> * cos[#<machine_rot>]]
	#<_measure_axis|1> = [#<_probe_axis|1> + #<_probe_off_axis|1> + #<diff> * sin[#<machine_rot>]]
	#<_measure_axis|2> = [#<_probe_axis|2> + #<_probe_off_axis|2>]
o<axnum> elseif [#<axis> EQ 1]
	#<_measure_axis|0> = [#<_probe_axis|0> + #<_probe_off_axis|0> - #<diff> * sin[#<machine_rot>]]
	#<_measure_axis|1> = [#<_probe_axis|1> - #<off> + #<diff> * cos[#<machine_rot>]]
	#<_measure_axis|2> = [#<_probe_axis|2> + #<_probe_off_axis|2>]
o<axnum> else
	#<_measure_axis|0> = [#<_probe_axis|0> + #<_probe_off_axis|0>]
	#<_measure_axis|1> = [#<_probe_axis|1> + #<_probe_off_axis|0>]
	#<_measure_axis|2> = [#<_probe_axis|2> - #<off> + #<diff>]
o<axnum> endif
;END -----------------------------------------------------------------------------------

(print, Gemessene Position: X#<_measure_x> Y#<_measure_y> Z#<_measure_z>)
#<_measure> = 1
#<_return> = #<_measure_axis|#<axis>>

M99 