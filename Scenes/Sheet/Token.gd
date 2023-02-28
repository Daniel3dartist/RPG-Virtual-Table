extends Node2D

onready var tilemap = self.get_parent().get_child(1)
var selected
var grabed

func _input(event):
	var mouse 
	var token 

	if Input.is_action_just_pressed("left_mouse"):
		mouse = tilemap.world_to_map(get_global_mouse_position())
		token = tilemap.world_to_map(self.position)
		if mouse == token:
			selected = true
			get_node("ColorRect").visible = true
			get_node("ColorRect").modulate = '73ffffff'
			get_node("Sprite").modulate = '73ccc1c1' #'e71a1a'
			grabed = true
		else:
			get_node("ColorRect").visible = false
			selected = false

	if grabed == true:
		var pos = tilemap.world_to_map(get_global_mouse_position())
		pos = tilemap.map_to_world(pos)
		self.position = pos

	if Input.is_action_just_released("left_mouse"):
		grabed = false
		get_node("Sprite").modulate = 'ffffff'
		get_node("ColorRect").modulate = 'ffffff'
