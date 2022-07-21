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


func _on_HSlider_T1_value_changed(value):
	Global.tension1 = value


func _on_HSlider_T2_value_changed(value):
	Global.tension2 = value


func _on_HSlider_T3_value_changed(value):
	Global.tension3 = value


func _on_HSlider_T4_value_changed(value):
	Global.tension4 = value


func _on_HSlider_T5_value_changed(value):
	Global.tension5 = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/stress/StressJoy.tscn")
