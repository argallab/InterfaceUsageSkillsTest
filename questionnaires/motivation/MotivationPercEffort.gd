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


func _on_HSlider11_value_changed(value):
	Global.motiv_q11 = value


func _on_HSlider12_value_changed(value):
	Global.motiv_q12 = value


func _on_HSlider13_value_changed(value):
	Global.motiv_q13 = value


func _on_HSlider14_value_changed(value):
	Global.motiv_q14 = value


func _on_HSlider15_value_changed(value):
	Global.motiv_q15 = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/motivation/MotivationEffort.tscn")
