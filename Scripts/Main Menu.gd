tool
extends Control

var next_scene 
export var load_table_menu : PackedScene

# Quit the APP from Main Menu
func _on_Exit_button_up():
	get_tree().quit()

# Load last table
func _on_Continue_button_up():
	get_tree().change_scene_to(next_scene)


func _on_Load_table_button_up():
	get_tree().change_scene_to(load_table_menu)
