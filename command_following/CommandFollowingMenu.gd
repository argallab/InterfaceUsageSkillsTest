extends Control

# Needed to use checkboxes
# var group = $NinePatchRect/VBoxContainer/CheckBox.group
onready var only_dir = get_node("NinePatchRect/VBoxContainer/CheckBox")
onready var mag_dir = get_node("NinePatchRect/VBoxContainer/CheckBox2")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.commands = []
	get_node("NinePatchRect/VBoxContainer/RepetitionsInput").text = str(Global.repetitions)
	
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/UpCheck").pressed = Global.up_check
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/DownCheck").pressed = Global.down_check
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/LeftCheck").pressed = Global.left_check
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/RightCheck").pressed = Global.right_check

	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/Q1Check").pressed = Global.q1_check
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/Q2Check").pressed = Global.q2_check
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/Q3Check").pressed = Global.q3_check
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/Q4Check").pressed = Global.q4_check
	
	get_node("NinePatchRect/VBoxContainer/MinTime/MinTimeInput").text = str(Global.min_time)
	get_node("NinePatchRect/VBoxContainer/MaxTime/MaxTimeInput").text = str(Global.max_time)
	
	if Global.magnitude:
		get_node("NinePatchRect/VBoxContainer/CheckBox2").pressed = true
	else:
		get_node("NinePatchRect/VBoxContainer/CheckBox").pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RepetitionsInput_text_changed(new_text):
	Global.repetitions = int(new_text)


func _on_MinTimeInput_text_changed(new_text):
	Global.min_time = int(new_text)


func _on_MaxTimeInput_text_changed(new_text):
	Global.max_time = int(new_text)


func _on_CheckBox_toggled(button_pressed):
	Global.magnitude = false


func _on_CheckBox2_toggled(button_pressed):
	Global.magnitude = true


func _on_Button_pressed():
	get_tree().change_scene("res://command_following/CommandFollowing.tscn")


func _on_UpCheck_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("up")
	else:
		Global.commands.erase("up")


func _on_DownCheck_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("down")
	else:
		Global.commands.erase("down")


func _on_LeftCheck_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("left")
	else:
		Global.commands.erase("left")


func _on_RightCheck_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("right")
	else:
		Global.commands.erase("right")


func _on_Q1Check_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("up-45")
	else:
		Global.commands.erase("up-45")


func _on_Q2Check_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("down-45")
	else:
		Global.commands.erase("down-45")


func _on_Q3Check_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("left-45")
	else:
		Global.commands.erase("left-45")


func _on_Q4Check_toggled(button_pressed):
	if button_pressed:
		Global.commands.append("right-45")
	else:
		Global.commands.erase("right-45")
