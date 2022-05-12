extends Button

onready var name_txt = self.text

signal call_sheet(value)


func _on_Sheet_button_up():
	var index = self.get_parent().get_index() - 1
	print(index)
	emit_signal("call_sheet", index)

