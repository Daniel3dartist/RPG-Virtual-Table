extends Panel

var press_color = '#ac98e0ff'
var selected_color = '#98e0ff'
var color = '#ffffff'


signal call_talent(id, _name)


func _on_HBoxContainer_gui_input(event):
	if self.modulate != Color(selected_color) and Input.is_action_just_released("left_mouse"):
			self.modulate = Color(selected_color)
	elif Input.is_action_just_released("left_mouse"):
		self.modulate = Color(color)


func _on_Talent_button_up():
	emit_signal("call_talent", self.get_index(), name)
