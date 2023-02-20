extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase.db"
var db_name_user = "user://userdatabase.db"

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = Directory.new();
	#Testing some functionality with Android 
	if !dir.file_exists(db_name_user):
		dir.copy(db_name, db_name_user);
		print("Copied db file to users dir")
	# Initialize the path to database
	db = SQLite.new()
	db.path = db_name_user
	db.open_db()

func _on_HSlider6_value_changed(value):
	Global.fatigue_q6 = value


func _on_HSlider7_value_changed(value):
	Global.fatigue_q7 = value



func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into FatigueQuestions (UserID, Physical1, Physical2, Physical3, Physical4, Physical5, Physical6, Physical7) values ('" + Global.user_ID
	db_query += "', '" + str(Global.fatigue_q1)
	db_query += "', '" + str(Global.fatigue_q2)
	db_query += "', '" + str(Global.fatigue_q3)
	db_query += "', '" + str(Global.fatigue_q4)
	db_query += "', '" + str(Global.fatigue_q5)
	db_query += "', '" + str(Global.fatigue_q6)
	db_query += "', '" + str(Global.fatigue_q7)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
