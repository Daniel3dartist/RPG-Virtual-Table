extends CheckBox

signal give_checks_data(data)
var current

func _ready():
	self.connect("pressed", self, "_gui_input")
	self.get_parent().connect('is_pressed', self, '_is_pressed')
	current = self.get_parent().get_parent().get_node("Points_Input/SpinBox")


func _gui_input(event):
	if event is InputEventMouseButton:
		emit_signal("give_checks_data", self.get_index())


func _is_pressed(id):
	print(id)
	if self.get_index() < id and self.pressed != true:
		if current.value < id:
			current.value = id + 1
			self.pressed = true
			self.modulate = 'ffffff'
	elif self.get_index() > id  and self.pressed == true:
		if current.value > id:
			current.value = id
			self.pressed = false
			self.modulate = '#fd7575'
