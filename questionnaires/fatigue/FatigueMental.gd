extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider9_value_changed(value):
	Global.fatigue_q9 = value


func _on_HSlider10_value_changed(value):
	Global.fatigue_q10 = value


func _on_HSlider11_value_changed(value):
	Global.fatigue_q11 = value


func _on_HSlider12_value_changed(value):
	Global.fatigue_q12 = value


func _on_HSlider13_value_changed(value):
	Global.fatigue_q13 = value


func _on_HSlider14_value_changed(value):
	Global.fatigue_q14 = value


func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into FatigueQuestions (UserID, Physical1, Physical2, Physical3, Physical4, Physical5, Physical6, Physical7, Physical8, Mental1, Mental2, Mental3, Mental4, Mental5, Mental6) values ('" + Global.user_ID
	db_query += "', '" + str(Global.fatigue_q1)
	db_query += "', '" + str(Global.fatigue_q2)
	db_query += "', '" + str(Global.fatigue_q3)
	db_query += "', '" + str(Global.fatigue_q4)
	db_query += "', '" + str(Global.fatigue_q5)
	db_query += "', '" + str(Global.fatigue_q6)
	db_query += "', '" + str(Global.fatigue_q7)
	db_query += "', '" + str(Global.fatigue_q8)
	db_query += "', '" + str(Global.fatigue_q9)
	db_query += "', '" + str(Global.fatigue_q10)
	db_query += "', '" + str(Global.fatigue_q11)
	db_query += "', '" + str(Global.fatigue_q12)
	db_query += "', '" + str(Global.fatigue_q13)
	db_query += "', '" + str(Global.fatigue_q14)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
