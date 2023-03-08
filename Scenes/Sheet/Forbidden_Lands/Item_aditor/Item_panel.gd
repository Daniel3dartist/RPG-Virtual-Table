extends Panel

var off_set
var is_block: bool = true
var dragging: bool = false

var press_color = '#ac98e0ff'
var selected_color = '#98e0ff'
var color = '#ffffff'



func _input(event):
	var _modulate
	if Input.is_action_just_pressed("left_mouse"):
		if self.modulate != Color(color):
			_modulate = color
		else:
			_modulate = selected_color
	# Drag-and-drop sheet
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		off_set = rect_position - get_global_mouse_position()
		var mouse = get_global_mouse_position()
		if is_block == false:
			print('Is mouse position\n')
#			set_default_cursor_shape(13)
			dragging = true
	if Input.is_action_just_released("left_mouse"):
		dragging = false
#		self.modulate = Color(selected_color)

func _process(delta):
	var mouse = get_global_mouse_position()
	if dragging == true and get_viewport().get_mouse_position().y > 0.0:
		var view = get_viewport().get_mouse_position()
		self.rect_position = view + off_set


func _on_HBoxContainer_gui_input(event):
	_select_deselect()



func _on_TextureRect_gui_input(event):
	_select_deselect()

	
	
func _select_deselect():
	if Input.is_action_just_released("left_mouse"):
		_set_select_color()


func _set_select_color():
	print('GUI01')
	if self.modulate == Color('#ffffff'):
		self.modulate = Color(selected_color)
		print('GUI02')
	else:
		self.modulate = Color(color)
		print('GUI03')


func _on_HBoxContainer_mouse_entered():
	is_block = true


func _on_HBoxContainer_mouse_exited():
	is_block = true


func _on_TextureRect_mouse_entered():
	is_block = true


func _on_TextureRect_mouse_exited():
	is_block = true
