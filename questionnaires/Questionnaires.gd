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


func _on_FatigueButton_pressed():
	get_tree().change_scene("res://questionnaires/fatigue/FatiguePhysical.tscn")


func _on_MotivationButton_pressed():
	get_tree().change_scene("res://questionnaires/motivation/MotivationIntEnjoy.tscn")


func _on_WorkloadButton_pressed():
	get_tree().change_scene("res://questionnaires/workload/WorkloadStart.tscn")


func _on_StimulantButton_pressed():
	get_tree().change_scene("res://questionnaires/stimulant_consumption/StimulantConsumption.tscn")


func _on_ConfidenceButton_pressed():
	get_tree().change_scene("res://questionnaires/confidence/Confidence.tscn")


func _on_StressButton_pressed():
	get_tree().change_scene("res://questionnaires/stress/StressWorries.tscn")
