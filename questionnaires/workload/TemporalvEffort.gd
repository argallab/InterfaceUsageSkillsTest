extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var temporal_effort = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Temporal_toggled(button_pressed):
	temporal_effort = 0


func _on_Effort_toggled(button_pressed):
	temporal_effort = 1


func _on_Button_button_up():
	if temporal_effort == 0:
		Global.temporal_sum += 1
	else:
		Global.effort_sum += 1
	get_tree().change_scene("res://questionnaires/workload/WorkloadScalesInfo.tscn")
