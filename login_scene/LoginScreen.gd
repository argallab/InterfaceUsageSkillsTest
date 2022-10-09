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
	db.open_db()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# When the user logs in, check the database to see if the given
# username and password exists in the database
# Log them in if it exists
# Give an error if it doesn't exist
func _on_LoginButton_pressed():
	var query_string : String = "SELECT * FROM TherapistInfo WHERE Username = ? AND Password = ?;"
	var param_bindings : Array = [username, password]
	var success = db.query_with_bindings(query_string, param_bindings)
	if not success:
		print("Query failure: " + db.error_message)
		return
	
	if db.query_result:
		print("Login successful")
		get_tree().change_scene("res://menu/Menu.tscn")
	else:
		print("Login failed. Please try again!")


# Adds given username and password to database if the user chooses to create a profile
func _on_CreateUserButton_pressed():
	var tableName = "TherapistInfo"
	var db_query = "insert into TherapistInfo (Username, Password) values ('"
	db_query += username
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
