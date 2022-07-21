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


func _on_HSlider_W1_value_changed(value):
	Global.worries1 = value


func _on_HSlider_W2_value_changed(value):
	Global.worries2 = value


func _on_HSlider_W3_value_changed(value):
	Global.worries3 = value


func _on_HSlider_W4_value_changed(value):
	Global.worries4 = value


func _on_HSlider_W5_value_changed(value):
	Global.worries5 = value


func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/stress/StressTension.tscn")
