extends Camera2D

var off_set
var can_move = false
var mouse
var motion
var dif

func _input(event):
	var mouse_position
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
#	if Input.is_action_just_pressed("BUTTON_MIDDLE"):
		mouse_position = get_viewport().get_mouse_position() 
		dif = get_viewport().get_mouse_position() 
		off_set = self.position - get_viewport().get_mouse_position() 
		
	if Input.is_action_pressed("BUTTON_MIDDLE"):
		can_move = true
	if not InputEventMouseMotion:
#	if Input.is_action_just_released("BUTTON_MIDDLE"):
		can_move = false
		motion = event.position

	if Input.is_action_just_released("BUTTON_MIDDLE"):
		can_move = false

	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP and self.zoom > Vector2(0.1, 0.1):
		self.zoom -= Vector2(0.05, 0.05)
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN and self.zoom < Vector2(6, 6):
		self.zoom += Vector2(0.05, 0.05)
	
	if event is InputEventMouseMotion:
		var mouse = get_viewport().get_mouse_position()
		if can_move == true:
#		 self.position -= (mouse - dif) * 0.08
	#	 self.position = mouse + off_set
		 self.position = mouse + off_set
#	elif can_move != false:
#		mouse_position = get_viewport().get_mouse_position() 
#		dif = get_viewport().get_mouse_position() 
#		off_set = self.position - get_viewport().get_mouse_position() 
#func _process(delta):
#	var mouse = get_viewport().get_mouse_position() 
#	if can_move == true:
#		self.position = mouse + off_set
	#	self.position -= (mouse - dif) * 0.08
