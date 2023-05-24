extends Area2D

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase.db"
var db_name_user = "user://userdatabase.db"



#Mouese controls Inits: 
var dtime = 0.0
var vel_mag_past = Vector2()
var mouse_pos = Vector2()
# Constants to determine max speeds
var rotation_speed = 0.01
var forward_speed = 0.8
# Part of the original code to generate the paths
var past_first_block = false  #used for final instructions (i.e. stop)
var on_curved_path = true

# Variables to calculate elapsed times
var time_start = 0.0
var time_now = 0.0

# Variables to calculate amount of time spent and number of times out of bounds
var time_exit = 0.0
var time_enter = 0.0
var nBB = 0
var time_outside = 0.0

# Variables to store the x and y inputs from the joystick
var inpx = 0.0
var inpy = 0.0
var curr_x_speed = 0.0
var curr_y_speed = 0.0

# Variables for calculating average speed
# Following dictionaries are for storing average speeds over each segment
var avg_speeds = {}
var avg_x_speeds = {}
var avg_y_speeds = {}
var avg_rot_speeds = {}

# Flag for if the wheelchair has started moving or not
# This is used to know when t=0 for calculating elapsed time should start
var started_moving = false

# Variables for calculating elapsed time over each portion of the track
var interval_start = 0.0
var interval_end = 0.0
var last_avg_speed = 0.0
var avg_rot_speed = 0.0
var x_speed = 0.0
var y_speed = 0.0
var start_x = 0.0
var start_y = 0.0
var start_rot = 0.0
var end_x = 0.0
var end_y = 0.0
var end_rot = 0.0

# Boolean variables for determining when to calculate average speeds
# Booleans for straight paths
var turn1 = false
var turn2 = false
var turn3 = false
var turn4 = false
var path1 = false
var path2 = false
var path3 = false
var path4 = false

# Booleans for curved path
var curve1 = false
var curve2 = false
var curve3 = false
var curve4 = false

# Variables to hold necessary values for calculating dimensionless jerk
var v_peak = 0
var curr_v_peak = 0.0
var curr_speed = 0.0
# Speed dicts go time : speed in ms
var v_speed_curve = {}
# Accel dicts go time : accel in ms
var accel_curve = {}
# Jerk dicts go time : jerk in ms
var jerk_curve = {}
# DLJ for each portion of the track
var dlj_curve = 0.0

#var input_type = "keyboard"
var input_type = "mouse_2"

# For Date and Time
var date_time 
var day
var month
var year
var hour
var minute

var elapsed_time
var time_good = 0.0
var time_bad = 0.0
var time_worse = 0.0

func _ready():
	# Initial x and y positions and rotation of wheelchair
#	position.x = 574
#	position.y = 504.96
#	rotation = 3.561592
	#get_node('../curve_collision_area').hide()
	
	var dir = Directory.new();
	#Testing some functionality with Android 
	if !dir.file_exists(db_name_user):
		dir.copy(db_name, db_name_user);
		print("Copied db file to users dir")
	# Initialize the path to database
	db = SQLite.new()
	db.path = db_name_user
	db.open_db()
	
	# Initialize the start time
	time_start = OS.get_ticks_msec()
	
	start_x = position.x
	start_y = position.y
	
	# global_translate(Vector2(40, 50))

func _process(delta):
	if input_type == "keyboard":
		# Store x and y inputs as 0 or 1 values based off arrow keys
		inpx = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
		inpy = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	elif input_type == "mouse_2": #HOPE THIS WORKS
		dtime = dtime + delta 
		Input.set_mouse_mode(2)
		var direction = mouse_pos.normalized()
		var angle_to_mouse = -direction.angle()
		if vel_mag_past == mouse_pos: 
			inpx = 0
			inpy = 0
		else: 
			mouse_to_controller(angle_to_mouse)
		vel_mag_past = mouse_pos
	else:
		# If using a controller, get the joystick positions for x and y
		inpx = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		inpy = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# If the joystick is moved for the first time
	if (inpx != 0 or inpy != 0) and started_moving == false:
		# Start the timer for the interval and change the started_moving flag
		started_moving = true
		interval_start = OS.get_ticks_msec()
	var angle  = rotation-PI/2
	
	# Update the wheelchair's position and rotation based off joystick
	curr_x_speed = forward_speed*inpy*cos(angle)
	curr_y_speed = forward_speed*inpy*sin(angle)
	position.x += curr_x_speed
	position.y += curr_y_speed
	rotation += rotation_speed*inpx
	
	# Update the current v_peak as necessary
	curr_speed = sqrt(pow(curr_x_speed, 2) + pow(curr_y_speed, 2))
	if curr_speed > curr_v_peak:
		curr_v_peak = curr_speed
	# Add to dict of speeds to eventually calculate jerks
	v_speed_curve[OS.get_ticks_msec()] = curr_speed
	
	finish()
	
func finish():
	var bot_y = 550
	var right_x = 550
	var left_x = 50
	var top_y = 50
	var pos_tol = 40
	var rot_tol = 10*PI/180
	var up_heading = PI
	var left_heading = PI/2
	var right_heading = -PI/2
	var down_heading = 0
	var rot = wrap_pi(rotation)
	
	# FIRST TURN BLOCK
	$direction_arrow.hide()
	$Camera2D/direction_label.set_text("Follow path")
	get_node('../curve_collision_area').show()	
	if abs(position.x - 2200) < pos_tol and abs(position.y-550) < pos_tol:
			$Camera2D/direction_label.set_text("Done")
			time_now = OS.get_ticks_msec()
			interval_end = OS.get_ticks_msec()
			end_x = position.x
			end_y = position.y
			x_speed = calc_avg_dir_speed(interval_start, interval_end, start_x, end_x)
			y_speed = calc_avg_dir_speed(interval_start, interval_end, start_y, end_y)
			last_avg_speed = calc_avg_speed(interval_start, interval_end, start_x, start_y, end_x, end_y)
			avg_speeds["path2"] = Vector2(last_avg_speed, interval_end-interval_start)
			avg_x_speeds["path2"] = Vector2(x_speed, interval_end-interval_start)
			avg_y_speeds["path2"] = Vector2(y_speed, interval_end-interval_start)
			accel_curve = calc_accel(v_speed_curve)
			jerk_curve = calc_abs_sq_jerks(accel_curve)
			v_peak = curr_v_peak
			dlj_curve = calc_avg_stability(interval_start, interval_end, v_peak, jerk_curve)
			elapsed_time = float((time_now - time_start) / 1000)
			#[time_good,time_bad] = calc_times(Global.time_outside_good,Global.time_outside_bad, Global.time_outside_worse, elapsed_time)
			time_good = Global.time_outside_good
			time_bad = Global.time_outside_bad - Global.time_outside_good
			time_worse = Global.time_outside_worse - (time_good+time_bad)
			var tOB = float(float(time_outside / 1000) / elapsed_time)
			var tOB_good = float(float(time_good/1000))
			var tOB_bad = float(float(time_bad/1000))
			var tOB_worse = float(float(time_worse/1000))
			print("good " + str(Global.time_outside_good))
			print("tOB_good " + str(tOB_good))
			var discretized_stability = calc_discretized_stability(tOB,tOB_worse,tOB_bad,tOB_good)
			
			Global.percent_oob = tOB
			
			# Calculate final average speed here
			for speed in avg_speeds:
				Global.avg_speed += avg_speeds[speed][0]
				
			print(avg_speeds.size())
			Global.avg_speed /= avg_speeds.size()
			
			for x_speed in avg_x_speeds:
				Global.avg_x_speed += avg_x_speeds[x_speed][0]
			Global.avg_x_speed /= avg_x_speeds.size()
			
			for y_speed in avg_y_speeds:
				Global.avg_y_speed += avg_y_speeds[y_speed][0]
			Global.avg_y_speed /= avg_y_speeds.size()
			
			#Global.avg_stability = dlj_curve
			Global.avg_stability = discretized_stability
			
			# Average dlj's
			# get Date and Time for upcoming SQL Query
			date_time = OS.get_datetime()
			day = str(date_time['day'])
			month = str(date_time ['month'])
			year = str(date_time['year'])
			hour = str(date_time['hour'])
			minute = str(date_time['minute'])
			date_time = month + "/" + day + "/" + year + "   " + hour + ":" + minute
			# SQL query
			db.open_db()
			var db_query = "insert into UserSignalsCurveTrajectory (UserID, nBB, tOB, PercentOB, avg_stability, avg_x_total, avg_y_total, avg_speed_total, avg_x_half1, avg_y_half1, avg_speed_half1, avg_x_half2, avg_y_half2, avg_speed_half2, Date, Time) values ('"
			db_query += Global.user_ID + "', '"
			#db_query += Global.trial_ID + "', '"
			db_query += str(nBB) + "', '"
			db_query += str(float(time_outside / 1000)) + "', '"
			db_query += str(Global.percent_oob) + "', '"
			db_query += str(discretized_stability) + "', '"
			db_query += str(Global.avg_x_speed) + "', '"
			db_query += str(Global.avg_y_speed) + "', '"
			db_query += str(Global.avg_speed) + "', '"
			db_query += str(Global.avg_x_speed) + "', '"
			db_query += str(Global.avg_y_speed) + "', '"
			db_query += str(Global.avg_speed) + "', '"
			db_query += str(Global.avg_x_speed) + "', '"
			db_query += str(Global.avg_y_speed) + "', '"
			db_query += str(Global.avg_speed) + "', '"
			db_query += date_time + "', '"
			db_query += str(elapsed_time) + "')"
			var success = db.query(db_query)
			if not success:
				print(db.error_message)
				
			Input.set_mouse_mode(0)
			get_tree().change_scene("res://trajectory_following/CurvedTrajectoryFollowingResults.tscn")

# Helper function to calculate average speed on straight paths
func calc_avg_speed(t_0, t_f, x_0, x_f, y_0, y_f):
	var numerator = sqrt(abs(pow(x_f - x_0, 2) - pow(y_f - y_0, 2)))
	var denom = t_f - t_0
	return numerator / denom * 1000
	
func calc_avg_dir_speed(t_0, t_f, u_0, u_f):
	return abs(u_f - u_0) / (t_f - t_0) * 1000
	
# Helper function to call before calculating stability/jerks
func calc_accel(speed_dict):
	var accel = {}
	var first_time = true
	var last_time = null
	var last_speed = null
	var curr_accel = 0.0
	for time in speed_dict:
		if !first_time:
			curr_accel = ((speed_dict[time] - last_speed) / (float(time - last_time)))
			accel[time] = curr_accel
		last_time = time
		last_speed = speed_dict[time]
		first_time = false
	return accel
	
func calc_abs_sq_jerks(accel_dict):
	var jerks = {}
	var first_time = true
	var last_time = null
	var last_accel = null
	var curr_jerks = 0.0
	for time in accel_dict:
		if !first_time:
			curr_jerks = ((accel_dict[time] - last_accel) / (float(time - last_time)))#/1000)
			jerks[time] = pow(abs(curr_jerks), 2)
		last_time = time
		last_accel = accel_dict[time]
		first_time = false
		
	return jerks
	
func calc_avg_stability(t_0, t_f, v_peak, jerks_dict):
	# Based off dimensionless jerk equation found in this paper:
	# https://jneuroengrehab.biomedcentral.com/track/pdf/10.1186/s12984-015-0090-9.pdf
	
	var first_time = true
	var last_time = null
	var last_jerks = null
	var riemann_sum = 0.0
	for time in jerks_dict:
		if !first_time:
			riemann_sum += ((jerks_dict[time] + last_jerks) / 2 * (float(time - last_time)) / 1000)
		last_time = time
		last_jerks = jerks_dict[time]
		first_time = false
		
	var dlj = -1 * pow((float(t_f - t_0) / 1000.0), 5) / pow(v_peak, 2) * riemann_sum
	return dlj

func wrap_pi(angle):
	while angle < -PI:
		angle += 2*PI
	
	while angle > PI:
		angle -= 2*PI
	return angle		
		
func calc_times(time_good,time_bad,time_worse,total_time): 
	var ntime_good = time_good - (time_bad+time_worse)
	var ntime_bad = time_bad - time_worse
	
	return[ntime_good,ntime_bad]
func calc_discretized_stability(tOB,tOBw, tOBb,tOBg):
	var discretized_stability = -1*(tOB+.75*tOBw + .50*tOBb + .25*tOBg) 
	discretized_stability = discretized_stability/elapsed_time
	print(str(tOB)+"\n")
	print(str(tOBb)+ "\n")
	print(str(tOBg) + "\n")
	print(str(discretized_stability))
	print(Global.time_outside_good)
	print(str(elapsed_time))
	return discretized_stability
	
# Collision detection for entering curved path
func _on_curve_collision_area_area_entered(area):
	if (on_curved_path):
		print("enter")
		time_exit = OS.get_ticks_msec()
		time_outside += (time_exit - time_enter)
		print(time_outside)

# Collision detection for exiting curved path
func _on_curve_collision_area_area_exited(area):
	if (on_curved_path):
		print("exit")
		nBB += 1
		time_enter = OS.get_ticks_msec()
		
func mouse_to_controller(angle_to_mouse): 
	if angle_to_mouse > PI/4 and angle_to_mouse < 3*PI/4: 
			inpy = -1
			inpx = 0
	elif (angle_to_mouse > 3*PI/4 and angle_to_mouse < PI) or (angle_to_mouse > -PI and angle_to_mouse < -3*PI/4) : 
			inpy = 0
			inpx = -1
	elif angle_to_mouse < -PI/4 and angle_to_mouse > -3*PI/4: 
			inpy = 1
			inpx = 0
	elif (angle_to_mouse > 0 and angle_to_mouse < PI/4) or (angle_to_mouse < 0 and angle_to_mouse > -PI/4):  
			inpy = 0
			inpx = 1

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var mouse_event = event as InputEventMouseMotion
		mouse_pos = mouse_event.get_relative()

func _on_BackButton_pressed():
	get_tree().change_scene("res://menu/Menu.tscn")



