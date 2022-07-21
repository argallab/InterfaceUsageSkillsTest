extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

var confidenceLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	confidenceLevel = value


func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into Confidence (UserID, ConfidenceLevel) values (" + Global.user_ID
	db_query += "', '" + str(confidenceLevel)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
