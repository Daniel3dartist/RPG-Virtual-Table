extends HBoxContainer

signal is_pressed(_bool, id)


var array: Array


func _ready():
	for i in self.get_child_count():
		if self.get_child(i).get_class() == 'CheckBox':
			self.get_child(i).connect('give_checks_data', self, '_give_checks_data')
			array.append(self.get_child(i))


func _give_checks_data(data, _bool):
	emit_signal("is_pressed", data, _bool)
		
