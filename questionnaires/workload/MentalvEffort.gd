extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mental_effort = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Mental_toggled(button_pressed):
	mental_effort = 0


func _on_Effort_toggled(button_pressed):
	mental_effort = 1


func _on_Button_button_up():
	if mental_effort == 0:
		Global.mental_sum += 1
	else:
		Global.effort_sum += 1
	get_tree().change_scene("res://questionnaires/workload/TemporalvMental.tscn")
