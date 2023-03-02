extends HBoxContainer

signal is_pressed(_bool, id)


func _ready():
	var array = []
	for i in self.get_child_count():
		if self.get_child(i).get_class() == 'CheckBox':
			self.get_child(i).connect('give_checks_data', self, '_give_checks_data')
			array.append(self.get_child(i))


func _give_checks_data(data):
	emit_signal("is_pressed", data)
