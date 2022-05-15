extends Node2D


var tile_size = self.cell_size
var grid_size = Vector2(40 , 30)

var color = "#ff0000"
var LINE_COLOR = Color("%s" % color)
var LINE_WIDTH = 3

func _ready():
	_draw()


func _draw():
	# Draw the backgroud grid rectangu
	var position = Vector2(0, 0) 
	var size = Vector2(grid_size.x*tile_size.x, (grid_size.y + 1) * tile_size.y) 
	draw_rect(Rect2(position, size), Color(1,1,1))
	
	# Draw grid line X
	for x in range(grid_size.x + 1):
		var col_pos = x  * tile_size.x 
		var limit = (grid_size.y + 1) * tile_size.y
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
	
	# Draw grid line y
	for y in range(grid_size.y + 2):
		var row_pos = y * tile_size.y
		var limit = grid_size.x * (tile_size.x)
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)


