(name,Gantry Square)
M999	;Startbedingungen prüfen


M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1

;check if U and V are available
#<cnt> = 0
o<loop> while [#<cnt> LE 8]
  o<chk> if [[#<_motoroutputorder_axis|#<cnt>> EQ 6] OR [#<_motoroutputorder_axis|#<cnt>> EQ 7]]
    (msg,Can not perform script if U or V axis is assigned to output)
    #<_sx_canceled> = 1
    M2
  o<chk> endif
  #<cnt> = [#<cnt> + 1]
o<loop> endwhile

;check axis
o<chkaxis> if [#<_gantrysquare_axis> LT 0]
  (msg,Square axis is not set)
  #<_sx_canceled> = 1
  M2
o<chkaxis> endif

;check direction and limit switches
#<pinu> = 0
#<pinv> = 0
o<chkdir> if [#<_gantrysquare_dir> EQ +1]
  o<chkpin> if [#<_limitpin_up> LE 0]
    (msg,Limit pin U+ is not set)
    #<_sx_canceled> = 1
    M2
  o<chkpin> endif
  o<chkpin> if [#<_limitpin_vp> LE 0]
    (msg,Limit pin V+ is not set)
    #<_sx_canceled> = 1
    M2
  o<chkpin> endif
  #<pinu> = #<_limitpin_up>
  #<pinv> = #<_limitpin_vp>
o<chkdir> elseif [#<_gantrysquare_dir> EQ -1]
  o<chkpin> if [#<_limitpin_un> LE 0]
    (msg,Limit pin U- is not set)
    #<_sx_canceled> = 1
    M2
  o<chkpin> endif
  o<chkpin> if [#<_limitpin_vn> LE 0]
    (msg,Limit pin V- is not set)
    #<_sx_canceled> = 1
    M2
  o<chkpin> endif
  #<pinu> = #<_limitpin_un>
  #<pinv> = #<_limitpin_vn>
o<chkdir> else
  (msg,Square direction is not set)
  #<_sx_canceled> = 1
  M2
o<chkdir> endif

;configure U and V axis
#<uv> = 0
#<cnt> = 0
o<loop> while [#<cnt> LE 8]
  o<chk> if [#<_motoroutputorder_axis|#<cnt>> EQ [#<_gantrysquare_axis>]]
    o<chkuv> if [#<uv> LT 2]
      #<_motoroutputorder_axis|#<cnt>> = [#<uv> + 6]
    o<chkuv> endif
    #<uv> = [#<uv> + 1]
  o<chk> endif
  #<cnt> = [#<cnt> + 1]
o<loop> endwhile

;check U and V axis
o<chkuv> if [#<uv> GT 2]
  (msg,More that two axes not allowed)
o<chkuv> elseif [#<uv> LT 2]
  (msg,Less that two axes not allowed)
o<chkuv> else
  G09
  M11P0
  G38.1 U#<_gantrysquare_dir> V#<_gantrysquare_dir> F#<_gantrysquare_speed>
  G04 P0.25
  G09
  #<ok> = 0
  o<chksw> if [[#<_hw_limit_num|#<pinu>>] AND [#<_hw_limit_num|#<pinv>>]]
    (print,Gantry is square)
    #<ok> = 1
  o<chksw> elseif [#<_hw_limit_num|#<pinu>>]
    #<tmp> = #<_hw_motor_v>
    G38.1 V#<_gantrysquare_dir>
    G09
    #<tmp> = ABS[#<_hw_motor_v> - #<tmp>]
    (print,Gantry is square, V axis difference was #<tmp>)
    #<ok> = 1
  o<chksw> elseif [#<_hw_limit_num|#<pinv>>]
    #<tmp> = #<_hw_motor_u>
    G38.1 U#<_gantrysquare_dir>
    G09
    #<tmp> = ABS[#<_hw_motor_u> - #<tmp>]
    (print,Gantry is square, U axis difference was #<tmp>)
    #<ok> = 1
  o<chksw> else
    (msg,Something is wrong! Gantry is not squared)
  o<chksw> endif

  ;move to compensate
  o<chkok> if [#<ok>]
    G91 G00 U[-#<_gantrysquare_dir> * #<_gantrysquare_move_u>] V[-#<_gantrysquare_dir> * #<_gantrysquare_move_v>]
    G90
  o<chkok> endif
  M11P1
o<chkuv> endif

;restore settings back
#<cnt> = 0
o<loop> while [#<cnt> LE 8]
  o<chk> if [[#<_motoroutputorder_axis|#<cnt>> EQ 6] OR [#<_motoroutputorder_axis|#<cnt>> EQ 7]]
    #<_motoroutputorder_axis|#<cnt>> = [#<_gantrysquare_axis>]
  o<chk> endif
  #<cnt> = [#<cnt> + 1]
o<loop> endwhile
G09

M2


