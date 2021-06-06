tool
extends Control

export var main_menu : PackedScene



func _on_Button_button_up():
	get_tree().change_scene_to(main_menu)
