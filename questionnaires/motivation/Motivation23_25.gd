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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider21_value_changed(value):
	Global.motiv_q21 = value


func _on_HSlider22_value_changed(value):
	Global.motiv_q22 = value


func _on_HSlider23_value_changed(value):
	Global.motiv_q23 = value


func _on_Button_button_up():
	db.open_db()
	var db_query = "insert into MotivationQuestions (UserID, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23) values ('" + Global.user_ID
	db_query += "', '" + str(Global.motiv_q1)
	db_query += "', '" + str(Global.motiv_q2)
	db_query += "', '" + str(Global.motiv_q3)
	db_query += "', '" + str(Global.motiv_q4)
	db_query += "', '" + str(Global.motiv_q5)
	db_query += "', '" + str(Global.motiv_q6)
	db_query += "', '" + str(Global.motiv_q7)
	db_query += "', '" + str(Global.motiv_q8)
	db_query += "', '" + str(Global.motiv_q9)
	db_query += "', '" + str(Global.motiv_q10)
	db_query += "', '" + str(Global.motiv_q11)
	db_query += "', '" + str(Global.motiv_q12)
	db_query += "', '" + str(Global.motiv_q13)
	db_query += "', '" + str(Global.motiv_q14)
	db_query += "', '" + str(Global.motiv_q15)
	db_query += "', '" + str(Global.motiv_q16)
	db_query += "', '" + str(Global.motiv_q17)
	db_query += "', '" + str(Global.motiv_q19)
	db_query += "', '" + str(Global.motiv_q20)
	db_query += "', '" + str(Global.motiv_q21)
	db_query += "', '" + str(Global.motiv_q22)
	db_query += "', '" + str(Global.motiv_q23)
	db_query += "')"
	db.query(db_query)
	
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
