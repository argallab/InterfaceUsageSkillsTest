extends Node

var user_ID
var trial_ID = "2"
var username = ""

# Variables to store inputs for command following menu
# Current values are standard values
var repetitions = 20
var commands = ["left", "right", "up", "down", "left-45", "right-45", "up-45", "down-45"]
var min_time = 1
var max_time = 2
var magnitude = false

var up_check = true
var down_check = true
var left_check = true
var right_check = true
var q1_check = true
var q2_check = true
var q3_check = true
var q4_check = true
# Variables to display on the results page after command following is done
var prompted_commands = 0
var num_correct = 0
var avg_response_time = 0.0
var num_settled = 0
var avg_settling_time = 0.0
# Accuracy variables
var init_response_acc = 0.0
var avg_settling_acc = 0.0

# Variables to display on trajectory results page
var avg_stability = 0.0
var avg_speed = 0.0
var avg_x_speed = 0.0
var avg_y_speed = 0.0
var avg_rot_speed = 0.0
var percent_oob = 0.0

# Variables for fatigue questionnaire answers
var fatigue_q1 = 0
var fatigue_q2 = 0
var fatigue_q3 = 0
var fatigue_q4 = 0
var fatigue_q5 = 0
var fatigue_q6 = 0
var fatigue_q7 = 0
var fatigue_q8 = 0
var fatigue_q9 = 0
var fatigue_q10 = 0
var fatigue_q11 = 0
var fatigue_q12 = 0
var fatigue_q13 = 0
var fatigue_q14 = 0

# Variables for motivation questionnaire answers
var motiv_q1 = 1
var motiv_q2 = 1
var motiv_q3 = 1
var motiv_q4 = 1
var motiv_q5 = 1
var motiv_q6 = 1
var motiv_q7 = 1
var motiv_q8 = 1
var motiv_q9 = 1
var motiv_q10 = 1
var motiv_q11 = 1
var motiv_q12 = 1
var motiv_q13 = 1
var motiv_q14 = 1
var motiv_q15 = 1
var motiv_q16 = 1
var motiv_q17 = 1
var motiv_q18 = 1
var motiv_q19 = 1
var motiv_q20 = 1
var motiv_q21 = 1
var motiv_q22 = 1
var motiv_q23 = 1

# Variables for stress questionnaire answers
var worries1 = 0
var worries2 = 0
var worries3 = 0
var worries4 = 0
var worries5 = 0
var tension1 = 0
var tension2 = 0
var tension3 = 0
var tension4 = 0
var tension5 = 0
var joy1 = 0
var joy2 = 0
var joy3 = 0
var joy4 = 0
var joy5 = 0
var demand1 = 0
var demand2 = 0
var demand3 = 0
var demand4 = 0
var demand5 = 0

# Variables for workload questionnaire
var mental_effort = 0
var temporal_mental = 0
var effort_physical = 0
var effort_performance = 0
var frustration_mental = 0
var physical_performance = 0
var physical_temporal = 0
var performance_mental = 0
var performance_temporal = 0
var temporal_frustration = 0
var performance_frustration = 0
var frustration_effort = 0
var physical_frustration = 0
var temporal_effort = 0
var mental_sum = 0
var frustration_sum = 0
var physical_sum = 0
var performance_sum = 0
var effort_sum = 0
var temporal_sum = 0
var mental_slider = 0
var frustration_slider = 0
var physical_slider = 0
var performance_slider = 0
var effort_slider = 0
var temporal_slider = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
