extends Button

signal playscene(index)

func _on_Play_Scene_button_up():
	var index = self.get_parent().get_parent().get_parent().get_parent().get_index()
	emit_signal("playscene", index)
