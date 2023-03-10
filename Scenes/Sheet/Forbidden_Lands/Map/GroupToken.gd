extends Sprite

var is_pressed: bool = false
var is_block: bool = true

func _input(event):
	if Input.is_action_pressed("left_mouse"):
		is_pressed = true
	elif Input.is_action_just_released("left_mouse"):
		is_pressed = false

func _process(delta):
	if is_pressed == true and is_block == false:
		var mouse = get_global_mouse_position()
		self.position = mouse


func _on_ColorRect_mouse_entered():
	is_block = false


func _on_ColorRect_mouse_exited():
	is_block = true
