extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var performance_temporal = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Performance_toggled(button_pressed):
	performance_temporal = 0


func _on_Temporal_toggled(button_pressed):
	performance_temporal = 1


func _on_Button_button_up():
	if performance_temporal == 0:
		Global.performance_sum += 1
	else:
		Global.temporal_sum += 1
	get_tree().change_scene("res://questionnaires/workload/MentalvPhysical.tscn")
