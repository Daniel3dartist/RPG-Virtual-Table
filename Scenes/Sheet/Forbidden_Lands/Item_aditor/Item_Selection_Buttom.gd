extends CheckBox

var num: int = 0
signal _edit_item(id)
signal _item_button_up(id, tab, _name)

#func _input(event):


func _on_CheckBox_item_pressed():
	emit_signal("_item_button_up", self.get_index(), null, self.text)
#	print(self.pressed)


func _on_CheckBox_item_gui_input(event):
	if Input.is_action_just_released("left_mouse"):
		if num < 1:
			num+=1
		else:
			emit_signal("_edit_item", self.get_index())
