M73
G17 G08 G15 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1

(dlgname,Direkt fahren)
(dlg,Fahre Kammera direkt zu X #<_selected_gcode_x,2>   Y #<_selected_gcode_y,2>?, typ=label, x=20, w=600, color=0xffffff)
(dlgshow)

O<PlanetCNC> if[#<_selected_gcode> GT 0]
G53 G00 X[#<_selected_gcode_x> - #<_cam_offset_x>] Y[#<_selected_gcode_y> - #<_cam_offset_y>]
O<PlanetCNC> endif
