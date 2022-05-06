extends HBoxContainer

signal delet_table(value)


func _on_Delete_Table_button_up():
	emit_signal("delet_table", self.get_index())
	print('Delete_table signal emited...')
	self.queue_free()


func _on_Edit_Table_button_up():
	pass # Replace with function body.
