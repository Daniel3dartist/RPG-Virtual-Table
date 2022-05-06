extends Button

signal playscene()

func _on_Play_Scene_button_up():
	emit_signal("playscene")
