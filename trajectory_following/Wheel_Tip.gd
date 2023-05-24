extends Area2D
###Helper Script for the discretized curved paths

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_exit_worse = 0.0
var time_enter_worse = 0.0
var time_outside_good = 0.0
var time_outside_bad = 0.0
var time_exit_bad = 0.0
var time_enter_bad = 0.0
var time_exit_good = 0.0
var time_enter_good = 0.0
var time_start = 0.0 
var time_end = 0.0 


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_bad_collison_area_area_entered(area):
		print("enter")
		time_exit_bad = OS.get_ticks_msec()
		Global.time_outside_bad = Global.time_outside_bad + (time_exit_bad - time_enter_bad)
		print("bad" + str(Global.time_outside_bad))

func _on_bad_collison_area_area_exited(area):
		time_enter_bad = OS.get_ticks_msec()


func _on_good_collision_area_area_entered(area):
		print("enter")
		time_exit_good = OS.get_ticks_msec()
		Global.time_outside_good = Global.time_outside_good + (time_exit_good - time_enter_good)
		print("good " + str(Global.time_outside_good))

func _on_good_collision_area_area_exited(area):
		time_enter_good = OS.get_ticks_msec()
		
	
func _on_worse_collision_area_area_entered(area):
	print("enter")
	time_exit_worse = OS.get_ticks_msec()
	Global.time_outside_worse = Global.time_outside_worse + (time_exit_worse - time_enter_worse)
	print("worse" + str(Global.time_outside_worse))
	
func _on_worse_collision_area_area_exited(area):
	time_enter_worse = OS.get_ticks_msec()
