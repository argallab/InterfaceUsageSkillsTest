extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

var had_stimulants = 1
var text_response = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CheckBox_toggled(button_pressed):
	had_stimulants = 1


func _on_CheckBox2_toggled(button_pressed):
	had_stimulants = 0


func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into StimulantConsumption (UserID, HadConsumed, TextResponse) values (" + Global.user_ID
	db_query += "', '" + str(had_stimulants)
	db_query += "', '" + text_response
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")


func _on_StimulantResponse_text_changed():
	text_response = $NinePatchRect/VBoxContainer/StimulantResponse.text
