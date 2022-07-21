extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MentalSlider_value_changed(value):
	Global.mental_slider = value


func _on_FrustrationSlider_value_changed(value):
	Global.frustration_slider = value


func _on_PhysicalSlider_value_changed(value):
	Global.physical_slider = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/workload/WorkloadRatingSheet2.tscn")
