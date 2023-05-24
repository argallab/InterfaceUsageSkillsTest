extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("NinePatchRect/VBoxContainer/Stability").text = "Average Stability: " + str(Global.avg_stability)
	get_node("NinePatchRect/VBoxContainer/AvgSpeed").text = "Average Total Speed: " + str(Global.avg_speed) + " pixels / sec"
	get_node("NinePatchRect/VBoxContainer/AvgXSpeed").text = "Average X Speed: " + str(Global.avg_x_speed) + " pixels / sec"
	get_node("NinePatchRect/VBoxContainer/AvgYSpeed").text = "Average Y Speed: " + str(Global.avg_y_speed) + " pixels / sec"
	get_node("NinePatchRect/VBoxContainer/OutofBounds").text = "% Out of Bounds: " + str(Global.percent_oob) + "%"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TaskButton_pressed():
	get_tree().change_scene("res://trajectory_following/Curved_Trajectory_Following.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://menu/Menu.tscn")

