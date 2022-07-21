extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CommandButton_pressed():
	get_tree().change_scene("res://command_following/CommandFollowing.tscn")


func _on_TrajectoryButton_pressed():
	get_tree().change_scene("res://trajectory_following/TrajectoryFollowing.tscn")


func _on_UserInfo_pressed():
	get_tree().change_scene("res://user_info/UserInfo.tscn")


func _on_UserResults_pressed():
	get_tree().change_scene("res://user_results/OutcomeResults.tscn")


func _on_Questionnaires_pressed():
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
