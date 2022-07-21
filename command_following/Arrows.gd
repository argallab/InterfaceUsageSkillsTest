extends Node2D

# class member variables go here, for example:

var follow_color = Color(0.1,.9,.05)
var off_color = Color(1,1,1)

var arrow_colors = [-1, -1, -1, -1] #Up, right, left, down
var color_dict = {-1: off_color, 1: follow_color}  
var arrow_index_dict = {"up": 0, "right": 1, "left": 2, "down": 3}

var count = 0

func _ready():
	pass
	
func _input(event):
	var arrow_node = get_node("../ArrowFeedback")
	var angle
	if event is InputEventKey and event.pressed:
		arrow_node.show()
		if event.scancode == KEY_UP:
			angle = 0
		elif event.scancode == KEY_DOWN:
			angle = PI
		elif event.scancode == KEY_LEFT:
			angle = -PI/2
		elif event.scancode == KEY_RIGHT:
			angle = PI/2
	else:
		print("hide")
		arrow_node.hide()
	update_arrow_colors()

# Arrow keys represent which arrow you are going
# Space bar is to pause
func _process(delta):
	if msg == 'pause':
		pause()
	elif msg in ['up','down','left','right']:
		toggle_arrow(msg)
	elif msg != 'none yet':
		print(msg)
		var arrow_node = get_node("../ArrowFeedback")
		var split_cmd = msg.split_floats(',')
		#pixel space inverts things (reasons for the negatives)
		var om = split_cmd[0]
		var v = split_cmd[1]
		if om == 0 and v == 0:
			print("hide")
			arrow_node.hide()
		else:
			arrow_node.show()
			var angle
			if om == 0:
				if v >0:
					angle = 0.0
				else:
					angle = PI	
			else:
				angle = -acos(v/om)
				if om <0:
					angle += PI
			arrow_node.rotation = angle
		update_arrow_colors()

func update_arrow_colors():
	var arrow_index = 0
	for arrow in self.get_children():
		arrow.color = color_dict[arrow_colors[arrow_index]]
		arrow_index += 1
		
func toggle_arrow(arrow_name):
	var i = arrow_index_dict[arrow_name]
	arrow_colors[i] = 1
	
func pause():
	for i in range(len(arrow_colors)):
		arrow_colors[i] = -1
