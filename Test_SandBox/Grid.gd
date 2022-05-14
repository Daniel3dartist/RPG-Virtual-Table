extends Node2D


var tile_size = self.cell_size
var grid_size = Vector2(64 , 64)
var grid = []

var color = "#FFFFFF"
var LINE_COLOR = Color("%s" % color)
var LINE_WIDTH = 2

func _ready():
	_draw()


func _draw():
	for x in range(grid_size.x):
		var col_pos = x * tile_size.x
		var limit = grid_size.y * tile_size.y
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
	for y in range(grid_size.y):
		var row_pos = y * tile_size.y
		var limit = grid_size.x * tile_size.x
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)

