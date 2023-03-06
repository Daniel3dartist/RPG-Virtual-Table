extends CheckBox

signal _item_button_up(id, tab, _name)

func _on_CheckBox_item_pressed():
	emit_signal("_item_button_up", self.get_index(), null, self.text)
#	print(self.pressed)
