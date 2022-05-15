extends HBoxContainer

signal delete_sheet(index)

func _on_Delete_button_up():
	emit_signal('delete_sheet', self.get_index())
	self.queue_free()
