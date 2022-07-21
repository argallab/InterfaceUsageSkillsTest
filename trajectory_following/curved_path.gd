extends Node2D

var pixel_scale = 30 

func _ready():
	pass

func _draw():
#	var center_small = Vector2(22.85, -1)*pixel_scale   #the orginal dimensions given by Mahdieh but changed to make the track smooth
	var center_small = Vector2(22.95, -1.42)*pixel_scale
	var radius_small = 5*pixel_scale
	var angle_from_small = 3*PI/2-atan(1/4.85)
	var angle_to_small = PI/2+atan(1/4.85)
	
	var center_large = Vector2(9, 4)*pixel_scale
	var radius_large = 10*pixel_scale
	var angle_from_large = atan(4.0/9.0)-PI/2 #from mahdiehs drawing
	var angle_to_large = -angle_from_large
	
	var color = Color(1.0, 1.0, 1.0)
	var thickness = 100
	draw_circle_arc_thick(center_small, radius_small, angle_from_small, angle_to_small, color, thickness)
	draw_circle_arc_thick(center_large, radius_large, angle_from_large, angle_to_large, color, thickness)
	
func draw_circle_arc_thick(center, radius, angle_from, angle_to, color,thickness):
	var points_arc = PoolVector2Array()
	var colors = PoolColorArray([color])
	
	points_arc.append_array(get_arc_points(center, radius-thickness/2, angle_from, angle_to))
	points_arc.append_array(get_arc_points(center, radius+thickness/2, angle_to, angle_from))
	draw_polygon(points_arc, colors)
	
func get_arc_points(center, radius, angle_from, angle_to):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points+1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - (PI/2)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	return points_arc
