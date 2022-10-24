extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

var user_sex = 0
var user_gender = 0
var user_handedness = 0
var user_interface = 0
var user_age = ""
var user_interface_use = ""
var user_injury = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_UserIDText_text_changed():
	pass # Replace with function body.


func _on_SubmitButton_pressed():
	var curr_user_ID = $NinePatchRect/VBoxContainer/HBoxContainer/UserIDText.text
	user_age = $NinePatchRect/VBoxContainer/HBoxContainer2/AgeText.text
	user_injury = $NinePatchRect/VBoxContainer/InjuryText.text
	user_interface_use = $NinePatchRect/VBoxContainer/HBoxContainer7/InterfaceUseText.text
	
	if curr_user_ID == "" or user_age == "" or user_injury == "" or user_sex == 0:
		$NinePatchRect/VBoxContainer/AcceptDialog.popup_centered()
	elif !user_age.is_valid_integer():
		$NinePatchRect/VBoxContainer/AcceptDialog2.popup_centered()
	else:
		db.open_db()
		db.query("SELECT UserID FROM UserInfo AS ui WHERE ui.UserID == " + curr_user_ID)
		if db.query_result.size() > 0:
			$NinePatchRect/VBoxContainer/ConfirmationDialog.popup_centered()
		
		else:
			add_to_sql(user_age, user_injury, user_interface_use)
			get_tree().change_scene("res://menu/Menu.tscn")


func add_to_sql(age, injury, interface_use):
	Global.user_ID = $NinePatchRect/VBoxContainer/HBoxContainer/UserIDText.text
	var db_query = "insert into UserInfo (UserID, Age, Sex, Gender, Handedness, Interface, InterfaceUse, Injury, Username) values ('"
	db_query += Global.user_ID + "', '"
	db_query += age + "', '"
	db_query += str(user_sex) + "', '"
	db_query += str(user_gender) + "', '"
	db_query += str(user_handedness) + "', '"
	db_query += str(user_interface) + "', '"
	db_query += interface_use + "', '"
	db_query += injury + "', '"
	db_query += Global.username + "')"
	db.query(db_query)


func _on_CancelButton_pressed():
	get_tree().change_scene("res://menu/Menu.tscn")


func _on_MaleCheckBox_toggled(_button_pressed):
	user_sex = 1


func _on_FemaleCheckBox_toggled(_button_pressed):
	user_sex = 2


func _on_GenderOptions_item_selected(index):
	user_gender = index


func _on_HandednessOptions_item_selected(index):
	user_handedness = index


func _on_ConfirmationDialog_confirmed(user_id):
	db.query("delete from UserInfo where UserID == " + user_id)
	add_to_sql(user_age, user_injury, user_interface_use)
	get_tree().change_scene("res://menu/Menu.tscn")


func _on_AcceptDialog_confirmed():
	pass # Replace with function body.


func _on_InterfaceOptions_item_selected(index):
	user_interface = index
