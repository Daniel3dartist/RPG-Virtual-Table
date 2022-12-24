extends Node2D

onready var tilemap = self.get_parent().get_child(1)

func _ready():
	print('Parente is: ',self.get_parent().get_child(1))

func _input(event):
	if Input.is_action_pressed("left_mouse"):
		var pos = tilemap.world_to_map(get_global_mouse_position())
		pos = tilemap.map_to_world(pos)
		self.position = pos
		print(tilemap.world_to_map(get_global_mouse_position()))
#		var mouseposition = tilemap.world_to_map(get_global_mouse_position())
#		var name = tilemap.tile_set.tile_get_name(28)
#		tilemap.set_cellv(mouseposition, tilemap.tile_set.find_tile_by_name(name))
