extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mental_physical = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Mental_toggled(button_pressed):
	mental_physical = 0


func _on_Physical_toggled(button_pressed):
	mental_physical = 1


func _on_Button_button_up():
	if mental_physical == 0:
		Global.mental_sum += 1
	else:
		Global.physical_sum += 1
	get_tree().change_scene("res://questionnaires/workload/TemporalvFrustration.tscn")
