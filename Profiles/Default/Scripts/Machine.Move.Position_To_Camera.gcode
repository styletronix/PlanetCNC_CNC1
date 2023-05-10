M999	;Startbedingungen prüfen
M104  ;Sichere Startposition

M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1
G00 X[#<_x> + #<_cam_offset_x>] Y[#<_y> + #<_cam_offset_y>]
