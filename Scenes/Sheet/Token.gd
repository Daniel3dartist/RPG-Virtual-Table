extends Node2D

onready var tilemap = self.get_parent().get_child(1)
var grabed

func _input(event):
#func _physics_process(delta):
	var mouse #= tilemap.world_to_map(get_global_mouse_position())
	var token #= tilemap.world_to_map(self.position) 
	print( '\nMouse: %s \nToken: %s \n' % [mouse, token])
	print('Grabed: ', grabed)

	if Input.is_action_just_pressed("left_mouse"):
		mouse = tilemap.world_to_map(get_global_mouse_position())
		token = tilemap.world_to_map(self.position)
		if mouse[0] == token[0] and mouse[1] == token[1]:
			print('\nGrabed == True\n')
			get_node("Sprite").modulate = 'e71a1a'
			grabed = true

	if grabed == true:
		print('grabed')
		var pos = tilemap.world_to_map(get_global_mouse_position())
		pos = tilemap.map_to_world(pos)
		self.position = pos

	if Input.is_action_just_released("left_mouse"):
		grabed = false
		get_node("Sprite").modulate = 'ffffff'

