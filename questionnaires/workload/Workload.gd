extends Control

var mentalVal = 1
var physicalVal = 1
var temporalVal = 1
var performanceVal = 1
var effortVal = 1
var frustrationVal = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MentalSlider_value_changed(value):
	mentalVal = value
	print(mentalVal)


func _on_PhysicalSlider_value_changed(value):
	physicalVal = value


func _on_TemporalSlider_value_changed(value):
	temporalVal = value


func _on_PerformanceSlider_value_changed(value):
	performanceVal = value


func _on_EffortSlider_value_changed(value):
	effortVal = value


func _on_FrustrationSlider_value_changed(value):
	frustrationVal = value


func _on_Button_button_up():
	# TODO: write to SQL database here
	get_tree().change_scene("res://questionnaires/Questionnaires.tscn")
