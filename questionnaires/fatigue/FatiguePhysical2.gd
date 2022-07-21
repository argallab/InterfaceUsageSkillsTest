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


func _on_HSlider6_value_changed(value):
	Global.fatigue_q6 = value


func _on_HSlider7_value_changed(value):
	Global.fatigue_q7 = value


func _on_HSlider8_value_changed(value):
	Global.fatigue_q8 = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/fatigue/FatigueMental.tscn")
