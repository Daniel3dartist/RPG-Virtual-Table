extends Button

signal roll_skill(_name, attribute, level, id)


func _ready():
	self.connect("button_up", self, '_on_button_up')


func _on_button_up():
	var attribute = self.get_parent().get_parent().get_parent().get_node("Label2").get_child(0).text
	var level = self.get_parent().get_node("SpinBox").value
	emit_signal("roll_skill", self.name, attribute, level, self.get_parent().get_index())
