extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

var count 
var icount#to check whether table is empty

var success #check if query happened

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db() # Replace with function body.

func _on_Delete_Command_pressed():
	success = db.query("SELECT count(*) FROM UserSignalsCommand;")
	count = db.query_result
	count = _filter_from_dbquery(count)
	if int(count) > 0:
		db.query("DELETE FROM UserSignalsCommand WHERE id = (SELECT MAX(id) FROM UserSignalsCommand);")
	else:
		$NinePatchRect/VBoxContainer/AlertDialogue.popup_centered()	
		
func _on_Delete_Trajectory_pressed():
	success = db.query("SELECT count(*) FROM UserSignalsTrajectory;")
	count = db.query_result
	count = _filter_from_dbquery(count)
	if int(count) > 0:
		db.query("DELETE FROM UserSignalsTrajectory WHERE id = (SELECT MAX(id) FROM UserSignalsTrajectory);")
	else:
		$NinePatchRect/VBoxContainer/AlertDialogue.popup_centered()	
		
func _on_Delete_Curved_pressed():
	success = db.query("SELECT count(*) FROM UserSignalsCurveTrajectory;")
	count = db.query_result
	count = _filter_from_dbquery(count)
	if int(count) > 0:
		db.query("DELETE FROM UserSignalsCurveTrajetory WHERE id = (SELECT MAX(id) FROM UserSignalsCurveTrajectory);")
	else:
		$NinePatchRect/VBoxContainer/AlertDialogue.popup_centered()		
		
func _on_BackButton_pressed():
	get_tree().change_scene("res://menu/Menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_AlertDialogue_confirmed():
	pass
	
func _filter_from_dbquery(query_result):
	var temp = ""
	var count = 0
	query_result = str(query_result)
	for character in query_result:
		if character == ":":
			count = 1 
			continue 
		if count == 1: 
			if character == "}":
				count = 0
			else:
				temp = temp + character
	return temp
