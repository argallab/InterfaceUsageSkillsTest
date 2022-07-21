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


func _on_HSlider_D1_value_changed(value):
	Global.demand1 = value


func _on_HSlider_D2_value_changed(value):
	Global.demand2 = value


func _on_HSlider_D3_value_changed(value):
	Global.demand3 = value


func _on_HSlider_D4_value_changed(value):
	Global.demand4 = value


func _on_HSlider_D5_value_changed(value):
	Global.demand5 = value


func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into StressQuestions (UserID, Worries1, Worries2, Worries3, Worries4, Worries5, Tension1, Tension2, Tension3, Tension4, Tension5, Joy1, Joy2, Joy3, Joy4, Joy5, Demand1, Demand2, Demand3, Demand4, Demand5) values ('" + Global.user_ID
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
	db_query += "', '" + str(Global.demand1)
	db_query += "', '" + str(Global.demand2)
	db_query += "', '" + str(Global.demand3)
	db_query += "', '" + str(Global.demand4)
	db_query += "', '" + str(Global.demand5)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
