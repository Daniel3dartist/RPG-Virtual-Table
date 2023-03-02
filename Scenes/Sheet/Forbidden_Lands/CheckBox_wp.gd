extends CheckBox


func _ready():
	self.connect("gui_input", self, "_gui_input")
	self.get_parent().connect('is_pressed', self, '_is_pressed')


func _gui_input(event):
	if event is InputEventMouseButton:
		emit_signal("give_checks_data", self.get_index())


func _is_pressed(id):
	print(id)
	if self.pressed != true:
			self.pressed = true
			self.modulate = 'ffffff'
	elif self.pressed == true:
			self.pressed = false
			self.modulate = '#fd7575'
