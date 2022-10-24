extends Polygon2D

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

# Variables to define the arrows and which direction it's pointing in the GUI
var follow_color = Color(0.1,.9,.05)
var off_color = Color(1,1,1)
var color_dict = {-1: off_color, 1: follow_color}
var arrow_list = ["left", "right", "up", "down", "left-45", "right-45", "up-45", "down-45"]
var arrow_str = "none"
var user_dir = "none"
var curr_target = null
var angle

var num_attempts = 0  # Keeps track of number of commands given
var prompt_start_time = 0  # Stores the time in milliseconds of when the command was given
var duration = 0  # Stores the duration of time
var response_time = 0  
var target_mag = 0
var scale_amount = 0

var sum_t_r = 0

var epsilon = 10 * PI / 180

# var input_type = "keyboard"
var input_type = "controller"
var input_vector = Vector2.ZERO
var input_theta = 0
var target_angle = 0

var started = false
var first_response = false
var commands_list = []
var durations_list = []
var magnitude_list = []
var command_index = 0

var rng = RandomNumberGenerator.new()

# Variables to help calculate settling time
var settling_vecs = []
var settling_threshold = 5
var sum_s_r = 0.0
var t_s = 0
var settled = false

# Variables for calculating accuracy
var sum_response_acc = 0.0
var acc_list = []
var sum_settling_acc = 0.0

var commands_per_rep = Global.commands.size()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	get_node("../Button").connect("pressed",self,"on_start_button")
	
	# Initialize SQL path
	db = SQLite.new()
	db.path = db_name
	
	# Set the number of attempts to 0 and empty the list of commands to give the user
	num_attempts = 0
	commands_list = []
	rng.randomize()
	
	# Set relevant Global variables to 0
	Global.prompted_commands = 0
	Global.num_correct = 0
	Global.num_settled = 0
	Global.avg_response_time = 0.0
	
	# If the user did not select magnitude in the menu
	# then do not display the magnitude
	if !Global.magnitude:
		get_node("../MagnitudeLabel").hide()
	
	generate_commands()

func _input(event):
	var arrow_node = get_node("../ArrowFeedback")
	# If the input is coming from the keyboard
	if event is InputEventKey and event.pressed:
		# Keyboard input can only do 4 directions
		if event.scancode == KEY_UP:
			angle = 0
			user_dir = "up"
		elif event.scancode == KEY_DOWN:
			angle = PI
			user_dir = "down"
		elif event.scancode == KEY_LEFT:
			angle = -PI/2
			user_dir = "left"
		elif event.scancode == KEY_RIGHT:
			angle = PI/2
			user_dir = "right"
		arrow_node.set_rotation(angle)
		arrow_node.show()
			
	# If the input is coming from a controller's joystick
	elif event is InputEventJoypadMotion:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		# Calculates the angle of the joystick from the x and y vectors above
		input_theta = atan2(input_vector.y, input_vector.x) + PI / 2
		arrow_node.set_rotation(input_theta)
		# If magnitude is checked, then get the polygon object of the arrow
		# and scale the arrow based off the magnitudes of the x and y vectors
		if Global.magnitude:
			var polygon : PoolVector2Array = arrow_node.polygon
			scale_amount = (abs(input_vector.x) + abs(input_vector.y)) / 2
			arrow_node.scale = Vector2(scale_amount, scale_amount)
		arrow_node.show()
			
	else:
		# If there is no current input, don't display the blue arrow
		user_dir = "none"
		arrow_node.hide()

func _process(delta):
	# Updating game stats when the input is the keyboard
	if input_type == "keyboard":
		# If the command direction is the same as the user's input direction
		if user_dir == arrow_str and user_dir != "none":
			# Increment the number of correct commands
			Global.num_correct += 1
			
			# Calculate response time/tR (time b/t prompt and correct response)
			var response_time = OS.get_ticks_msec()
			# Add to the sum of total time it takes for user to respond correctly
			sum_t_r += (response_time - prompt_start_time)
			
			if curr_target != null:
				curr_target.hide()
			target_arrow()
		elif user_dir == "none":
			num_attempts += 1
	# Updating game stats when the input is a controller
	elif input_type == "controller":
		if started == true:
			
			var curr_time = OS.get_ticks_msec()
			
			# If the amount of time that has passed since the command was given
			# is larger than the given duration
			if curr_time - prompt_start_time >= duration * 1000:
				# Check if it has settled
				if settled:
					# If it has, calculate the settling accuracy of the user's command
					var curr_acc = 0.0
					for diff in acc_list:
						curr_acc += 1 - diff
					
					curr_acc /= acc_list.size()
					sum_settling_acc += curr_acc
				# Increment the number of given commands
				Global.prompted_commands += 1
				if curr_target != null:
					curr_target.hide()
				target_arrow()
			
			# Angle checking for controller
			if target_angle - epsilon <= input_theta and input_theta <= target_angle + epsilon and scale_amount >= target_mag:
				
				# If it's the first time that the user responded correctly
				if first_response:
					# Calculate response time/tR (time b/t prompt and correct response)
					# and add to a running sum of the total time it takes to respond correctly
					response_time = OS.get_ticks_msec()
					sum_t_r += (response_time - prompt_start_time)
					# Increment the sum of the response accuracy
					sum_response_acc += 1 - abs(target_angle - input_theta)
					# Increment the number of correct responses given
					Global.num_correct += 1
					# Change the first response flag b/c following responses are no
					# longer the first response
					first_response = false
				
				# If it's not the first response
				else:
					# Calculate settling time:
					# Keep a queue of the last n vector readings
					# If the last n vector readings are within epsilon of the desired vector
					# Record the settling time as the current time
					settling_vecs.append(input_theta)
					if settling_vecs.size() >= settling_threshold and !settled:
						t_s = OS.get_ticks_msec()
						sum_s_r += (t_s - prompt_start_time)
						Global.num_settled += 1
						settled = true
					
					# Add to the list of angle differences if settled flag is true
					if settled:
						acc_list.append(abs(target_angle - input_theta))
			else:
				# Empty the settling vector
				# Change first response flag again b/c we're looking for the first response again
				settling_vecs = []
				if !first_response:
					first_response = true
					
	if Global.prompted_commands >= Global.commands.size() * Global.repetitions:
		# write to SQL database here
		Global.avg_response_time = float(sum_t_r / Global.num_correct) / 1000.0
		Global.avg_settling_time = float(sum_s_r / Global.num_correct) / 1000.0
		Global.init_response_acc = float(sum_response_acc / Global.num_correct)
		Global.avg_settling_acc = float(sum_settling_acc / Global.num_correct)
		
		db.open_db()
		var db_query = "insert into UserSignalsCommand (UserID, tR, percentR, tS, percentS, init_rA, avg_sA) values ('"
		db_query += Global.user_ID + "', '"
		#db_query += Global.trial_ID + "', '" shouldn't be necessary, autoincrements 
		db_query += str(Global.avg_response_time) + "', '"
		db_query += str(float(Global.num_correct) / float(Global.prompted_commands)) + "', '"
		db_query += str(Global.avg_settling_time) + "', '"
		db_query += str(float(Global.num_settled) / float(Global.prompted_commands)) + "', '"
		db_query += str(Global.init_response_acc) + "', '"
		db_query += str(Global.avg_settling_acc) + "')"
		db.query(db_query)
		
		get_tree().change_scene("res://command_following/CommandFollowingResults.tscn")
		
# Function to generate the arrow directions, durations, and magnitudes for the entire run
# Is called inside the ready() function
func generate_commands():
	for i in range(Global.commands.size()):
		var next_command = randi() % Global.commands.size()
		if commands_list.size() > 0:
			while next_command == commands_list[-1]:
				next_command = randi() % Global.commands.size()
		commands_list.append(next_command)
		durations_list.append(randi() % (Global.max_time - Global.min_time) + Global.min_time)
		if Global.magnitude:
			magnitude_list.append(rng.randf_range(0.0, 0.5))
	

# Gets the direction (and magnitude) of the current command arrow from the commands list
# and displays the appropriate arrow for that command
func target_arrow():
	first_response = true
	settled = false
	var arrow_index = commands_list[command_index]
	arrow_str = Global.commands[arrow_index]
	if arrow_str == "left":
		curr_target = get_node("../Arrows/ArrowLeft")
		target_angle = 3 * PI / 2
	elif arrow_str == "left-45":
		curr_target = get_node("../Arrows/ArrowLeft2")
		target_angle = 7 * PI / 4
	elif arrow_str == "right":
		curr_target = get_node("../Arrows/ArrowRight")
		target_angle = PI / 2
	elif arrow_str == "right-45":
		curr_target = get_node("../Arrows/ArrowRight2")
		target_angle = 3 * PI / 4
	elif arrow_str == "up":
		curr_target = get_node("../Arrows/ArrowUp")
		target_angle = 0
	elif arrow_str == "up-45":
		curr_target = get_node("../Arrows/ArrowUp2")
		target_angle = PI / 4
	elif arrow_str == "down":
		curr_target = get_node("../Arrows/ArrowDown")
		target_angle = PI
	elif arrow_str == "down-45":
		curr_target = get_node("../Arrows/ArrowDown2")
		target_angle = 5 * PI / 4
	curr_target.show()
	
	# Gets the time in milliseconds that the arrow is first displayed
	# This is used to ensure that the arrow is displayed for the right duration
	prompt_start_time = OS.get_ticks_msec()
	duration = durations_list[command_index]
	
	# If magnitude is checked, then this also gets the desired magnitude of the command
	# Also sets the texts for the magnitude
	if Global.magnitude:
		target_mag = magnitude_list[command_index]
		get_node("../MagnitudeLabel").set_text("Magnitude of command: " + str(target_mag))

	# Set the text for the current number of commands and duration
	get_node("../DurationLabel").set_text("Command Duration: " + str(duration) + " sec")
	get_node("../CommandsLabel").set_text("Commands Given: " + str(Global.prompted_commands + 1))
	
	# Increment the command index
	command_index += 1
	if command_index >= commands_per_rep:
		command_index -= commands_per_rep

# Button to start the task, hide relevant elements, and display the first command
func on_start_button():
	var start_str = "start"
	# godot2ros_node.send_msg_to_ros(start_str)
	get_node("../Button").hide()
	self.get_node(".").hide()
	print("started")
	started = true
	target_arrow()
	
func pause():
	hide()
	
# Button to go back to main menu
func _on_BackButton_pressed():
	get_tree().change_scene("res://menu/Menu.tscn")

# Button to go to command following settings menu
func _on_MenuButton_pressed():
	get_tree().change_scene("res://command_following/CommandFollowingMenu.tscn")
