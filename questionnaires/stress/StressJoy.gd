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


func _on_HSlider_J1_value_changed(value):
	Global.joy1 = value


func _on_HSlider_J2_value_changed(value):
	Global.joy2 = value


func _on_HSlider_J3_value_changed(value):
	Global.joy3 = value


func _on_HSlider_J4_value_changed(value):
	Global.joy4 = value


func _on_HSlider_J5_value_changed(value):
	Global.joy5 = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/stress/StressDemands.tscn")
