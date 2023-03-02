extends HBoxContainer

signal is_pressed(_bool, id)

func _ready():
	for i in self.get_child_count():
		self.get_child(i).connect('give_checks_data', self, '_give_checks_data')


func _give_checks_data(data):
	emit_signal("is_pressed", data)


