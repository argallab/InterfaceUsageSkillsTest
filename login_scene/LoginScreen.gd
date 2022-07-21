extends Control

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"
var username = ""
var password = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the path to database
	db = SQLite.new()
	db.path = db_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# When the user logs in, check the database to see if the given
# username and password exists in the database
# Log them in if it exists
# Give an error if it doesn't exist
func _on_LoginButton_pressed():
	var db_query = "select * from UserInfo where Username = '"
	db_query += username
	db_query += "' and Password = '"
	db_query += password
	db_query += "'"
	db.query(db_query)
	if db.query_result.size() > 0:
		print("Login successful!")
	else:
		print("Login failed. Please try again.")
	get_tree().change_scene("res://menu/Menu.tscn")

# Adds given username and password to database if the user chooses to create a profile
func _on_CreateUserButton_pressed():
	db.open_db()
	var tableName = "UserInfo"
	var db_query = "insert into UserInfo (UserName, Password) values ('"
	db_query += tableName # mahdieh changed from username
	db_query += "', '"
	db_query += password
	db_query += "')"
	db.query(db_query)

	# dict["UserName"] = "ssinaga"
	# dict["Password"] = "0328"
	
	# db.insert_row(tableName, dict)

# Change the variable string stored for the username as the user types it in
func _on_Username_text_changed(new_text):
	username = new_text

# Change the variable string stored for the password as the user types it in
func _on_Password_text_changed(new_text):
	password = new_text
