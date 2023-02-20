extends Control

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase.db"
var db_name_user = "user://userdatabase.db"




# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
	db.open_db()
	var db_query = "insert into StressQuestions (UserID, Worries1, Worries2, Worries3, Worries4, Worries5, Tension1, Tension2, Tension3, Tension4, Tension5, Joy1, Joy2, Joy3, Joy4, Joy5) values ('" + Global.user_ID
	db_query += "', '" + str(Global.worries1)
	db_query += "', '" + str(Global.worries2)
	db_query += "', '" + str(Global.worries3)
	db_query += "', '" + str(Global.worries4)
	db_query += "', '" + str(Global.worries5)
	db_query += "', '" + str(Global.tension1)
	db_query += "', '" + str(Global.tension2)
	db_query += "', '" + str(Global.tension3)
	db_query += "', '" + str(Global.tension4)
	db_query += "', '" + str(Global.tension5)
	db_query += "', '" + str(Global.joy1)
	db_query += "', '" + str(Global.joy2)
	db_query += "', '" + str(Global.joy3)
	db_query += "', '" + str(Global.joy4)
	db_query += "', '" + str(Global.joy5)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")

