extends Button

func _on_Main_Menu_button_up():
	var main_menu = 'res://Scenes/Main Menu/Main Menu.tscn'
	get_tree().change_scene(main_menu)
