extends Control

export var line_width = 5
export(Color) var line_color
export(Color) var bg_color

export var x_label = "Trial #"
export var y_label = ""

var x_ticks
var y_ticks
var plottable

var x_numerical = true
var y_numerical = true

var min_x
var min_y
var max_x
var max_y

var line_rect_width
var line_rect_height

var line_rect_x
var line_rect_y

var ex_data = [
	{'x': 'MON', 'y': 7.0},
	{'x': 'TUE', 'y': 8.0},
	{'x': 'WED', 'y': 3.0},
	{'x': 'THU', 'y': 5.0},
	{'x': 'FRI', 'y': 4.0},
	{'x': 'SAT', 'y': 6.0},
	{'x': 'SUN', 'y': 1.0},
]

var data = []

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://UserDataStore/userdatabase"

var curr_value = 0
var curr_index = 0
var category = ""
var command_vars = ["tR", "percentR", "tS", "percentS", "init_rA", "avg_sA"]
var trajectory_vars = ["nBB", "tOB", "PercentOB", "avg_stability", "avg_x_total",
"avg_y_total", "avg_speed_total", "avg_x_half1", "avg_y_half1", "avg_speed_half1",
"avg_x_half2", "avg_y_half2", "avg_speed_half2", "avg_rot_half1", "avg_rot_half2",
"avg_rot_total"]
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db()

	draw_graph()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if curr_value != curr_index:
		print("curr value: ", curr_value)
		print("curr index: ", curr_index)
		# Clear the current graph
		delete_graph()
		
		# Redraw everything
		curr_index = curr_value
		draw_graph()


func _on_OptionButton_item_selected(index):
	curr_value = index

func get_val(val, idx):
	print("Val:", val)
	if [TYPE_REAL].has(typeof(val)):
		print("returned val")
		val = int(val)
		return val
	print("returned index")
	return idx
	
func scale_x(val):
	var dx = max_x - min_x
	if dx == 0:
		dx = 1
	return ((val - min_x) * line_rect_width / dx) + line_rect_x/2

func scale_y(val):
	var dy = max_y - min_y
	if dy == 0:
		dy = 1
	return line_rect_height - ((val - min_y) * line_rect_height / dy) + line_rect_y

func draw_graph():
	# generate line and apply style
	var line = Line2D.new()
	line.width = line_width
	line.default_color = line_color
	# Grab data from SQL
	if curr_value <= 5:
		category = command_vars[curr_value]	
		db.query("SELECT " + category + " FROM UserSignalsCommand WHERE UserID = '" + Global.user_ID + "';")
	else:
		category = trajectory_vars[curr_value - 6]
		db.query("SELECT " + category + " FROM UserSignalsTrajectory WHERE UserID = " + Global.user_ID + ";")
	y_label = category
	print(y_label)
	print(db.query_result)
	for i in db.query_result:
		data.append({'x': str(counter), 'y': i[category]})
		counter += 1
			
	x_ticks = data.size()
	y_ticks = data.size()
	
	if x_ticks == 0:
		plottable = "no"
	if x_ticks == 1:
		plottable = "point"
	if x_ticks > 1: 
		plottable = "line"
	
	$HBoxContainer/VBoxContainer4/LineContainer.add_child(line)
	
	$HBoxContainer/VBoxContainer4/x_label.text = x_label
	$HBoxContainer2/y_label.text = y_label
	$HBoxContainer/VBoxContainer4/LineContainer/Background.color = bg_color

	# check if values are numerical
	for val in data:
		if not [TYPE_REAL].has(typeof(val['x'])):
			x_numerical = false
		if not [TYPE_REAL].has(typeof(val['y'])):
			y_numerical = false
		
	# get min and max values (use index if value isn't a number, e.g. weekdays)
	for i in range(len(data)):
		var x_val = get_val(data[i]['x'], i)
		var y_val = get_val(data[i]['y'], i)
		
		if min_x == null or x_val < min_x:
			min_x = x_val
		if max_x == null or x_val > max_x:
			max_x = x_val
		if min_y == null or y_val < min_y:
			min_y = y_val
		if max_y == null or y_val > max_y:
			max_y = y_val
	
	# add tick labels to each axis
	for i in range(x_ticks):
		var x_tick = Label.new()
		x_tick.size_flags_horizontal = SIZE_EXPAND_FILL
		x_tick.align = HALIGN_CENTER
		#if x_numerical:
			#x_tick.text = str(i * (max_x-min_x) / (x_ticks-1) + min_x) # optional rounding
		#else:
		x_tick.text = str(truncate(data[i]['x'], 2))
		$HBoxContainer/VBoxContainer4/x_ticks_container.add_child(x_tick)
	for i in range(y_ticks-1, -1, -1):
			var y_tick = Label.new()
			y_tick.size_flags_vertical = SIZE_EXPAND_FILL
			y_tick.valign = VALIGN_CENTER
			#if y_numerical:
				#y_tick.text = str(stepify(i * (max_y-min_y) / (y_ticks-1) + min_y, 0.001)) # optional rounding
			#else:
			y_tick.text = str(truncate(data[y_ticks-i-1]['y'], 2))
			print(y_tick.text)
			$HBoxContainer2/y_ticks_container.add_child(y_tick)
	
		# fix updated rect sizes not having correct values after altering labels
	yield(get_tree(), "idle_frame") or yield(VisualServer, "frame_post_draw")
	
	# shape the line
	line_rect_width = $HBoxContainer/VBoxContainer4/LineContainer.rect_size.x
	line_rect_height = $HBoxContainer/VBoxContainer4/LineContainer.rect_size.y
	
	print("orig width: ", line_rect_width)
	print("orig height: ", line_rect_height)
	
	if plottable != "no":
		line_rect_x = (line_rect_width / x_ticks)
		line_rect_y = (line_rect_height / y_ticks)
		
		line_rect_width = line_rect_x * (x_ticks-1)
		line_rect_height = line_rect_y * (y_ticks-1)
		
		print("new width: ", line_rect_width)
		print("new height: ", line_rect_height)
		
	for i in range(len(data)):
		var scaled_x = scale_x(get_val(data[i]['x'], i))
		var scaled_y = scale_y(get_val(data[i]['y'], i))
		#truncating: 
		scaled_x = truncate(scaled_x, 2)
		scaled_y = truncate(scaled_y, 2)
		#plotting a "point" (a tight, small line that looks circular, for those more knowledgable who wish to optimize: see draw_primitive()
		if plottable == "point":
			for j in range(2):
				line.add_point(Vector2(scaled_x+1,scaled_y-165))
				line.add_point(Vector2(scaled_x,scaled_y-166))
				line.add_point(Vector2(scaled_x-1,scaled_y-165))
				line.add_point(Vector2(scaled_x,scaled_y-164))
		else:
			line.add_point(Vector2(scaled_x, scaled_y - 65))

func delete_graph():
	# Clear all node children that need to be redrawn
	delete_child($HBoxContainer/VBoxContainer4/LineContainer)
	delete_child($HBoxContainer/VBoxContainer4/x_ticks_container)
	delete_child($HBoxContainer2/y_ticks_container)
	
	# Empty the data
	data = []
	min_x = null
	max_x = null
	min_y = null
	max_y = null
	
	# Clear the current y tick labels
	
	# Clear trial number
	counter = 0
		
func delete_child(curr_node):
	for n in curr_node.get_children():
		if n != $HBoxContainer/VBoxContainer4/LineContainer/Background:
			curr_node.remove_child(n)
			n.queue_free()
func truncate(number, digits):
		if len(str(number).rsplit('.')) > 1:
			var nbDecimals = len(str(number).rsplit('.')[1])
			if nbDecimals <= digits:
				return number
			var stepper = pow(10.0,digits)
			number = floor(stepper*number)/stepper
			return number
		else:
			return number
	
