extends CheckBox

var is_enter: bool = false

func _ready():
	self.connect("mouse_entered", self, 'mouse_entered')
	self.connect("mouse_exited", self, 'mouse_exited')


func _input(event):
	if Input.is_action_just_released("left_mouse"):
		if self.pressed == true and is_enter == true:
			self.pressed = false


func mouse_entered():
	is_enter = true

func mouse_exited():
	is_enter = false
