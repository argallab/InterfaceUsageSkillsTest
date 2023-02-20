extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider16_value_changed(value):
	Global.motiv_q16 = value


func _on_HSlider17_value_changed(value):
	Global.motiv_q17 = value


func _on_HSlider18_value_changed(value):
	Global.motiv_q18 = value

func _on_HSlider19_value_changed(value):
	Global.motiv_q19 = value
	
func _on_HSlider20_value_changed(value):
	Global.motiv_q20 = value

func _on_Button_button_up():
	get_tree().change_scene("res://questionnaires/motivation/Motivation23_25.tscn")
