extends Camera2D

var off_set
var can_move = false
var mouse
var motion

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		off_set = self.position - get_viewport().get_mouse_position()
		if event.is_pressed() == false:
			can_move = false
		else:
			can_move = true

	if event is InputEventMouseMotion and can_move == true:
		motion = event.position
	elif can_move == true:
		motion = get_viewport().get_mouse_position()

	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP and self.zoom > Vector2(0.1, 0.1):
		self.zoom -= Vector2(0.05, 0.05)
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN and self.zoom < Vector2(6, 6):
		self.zoom += Vector2(0.05, 0.05)
	

func _process(delta):
	var mouse = get_viewport().get_mouse_position() 
	if can_move == true:
		self.position =  mouse  + off_set
		
