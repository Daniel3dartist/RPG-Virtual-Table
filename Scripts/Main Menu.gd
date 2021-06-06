extends Control

var next_scene = 'res://Scenes/Table.tscn'
var load_table_menu = 'res://Scenes/Load Table Menu.tscn'

var settings_menu = 'res://Scenes/Settings.tscn'

# Quit the APP from Main Menu
func _on_Exit_button_up():
	get_tree().quit()

# Load last table
func _on_Continue_button_up():
	get_tree().change_scene(next_scene)


func _on_Load_table_button_up():
	get_tree().change_scene(load_table_menu)


func _on_Settings_button_up():
	get_tree().change_scene(settings_menu)
