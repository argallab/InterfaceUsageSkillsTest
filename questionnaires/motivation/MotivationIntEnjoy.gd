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


func _on_HSlider1_value_changed(value):
	Global.motiv_q1 = value


func _on_HSlider2_value_changed(value):
	Global.motiv_q2 = value


func _on_HSlider3_value_changed(value):
	Global.motiv_q3 = value


func _on_HSlider4_value_changed(value):
	Global.motiv_q4 = value


func _on_HSlider5_value_changed(value):
	Global.motiv_q5 = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/motivation/MotivationEnjoyPerc.tscn")
