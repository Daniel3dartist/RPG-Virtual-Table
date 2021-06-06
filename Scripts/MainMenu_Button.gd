extends Button

var main_menu = 'res://Scenes/Main Menu.tscn'

func _on_Main_Menu_button_up():
	get_tree().change_scene(main_menu)
