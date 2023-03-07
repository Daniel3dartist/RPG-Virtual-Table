extends Panel

var selected_color = '#98e0ff'
var color = '#ffffff'


func _on_HBoxContainer_gui_input(event):
	_select_deselect()


func _on_TextureRect_gui_input(event):
	_select_deselect()
	
	
func _select_deselect():
	if Input.is_action_just_released("left_mouse"):
		if self.modulate == Color('#ffffff'):
			self.modulate = selected_color
		else:
			self.modulate = color
