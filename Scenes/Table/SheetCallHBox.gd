extends HBoxContainer

signal delete_sheet(index)
signal call_sheet(dic)

func _on_Delete_button_up():
	emit_signal('delete_sheet', self.get_index())
	self.queue_free()


func _on_Sheet_button_up():
	var dic : Dictionary = {
		'id':self.get_index(),
		'path': $'path'.text
	}
	emit_signal("call_sheet", dic)


func _on_Sheet_renamed():
	pass
