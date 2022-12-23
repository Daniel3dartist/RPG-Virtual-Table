extends TileMap



var tile_size = self.cell_size
var grid_size = Vector2(40 , 30)

var color = "#5c5c5c"
var LINE_COLOR = Color("%s" % color)
var LINE_WIDTH = 3
var BG = Color(1,1,1)

onready var table = self.get_parent().get_parent().get_parent()

func _ready():
	print('grid tree ', self.get_parent().get_parent().get_parent())
	print('Table name? ', table)
	table.connect('grid_settings', self, '_Grid_Settings')


func _draw():
	# Draw the backgroud grid rectangu
	var position = Vector2(0, 0) 
	var size = Vector2(grid_size.x*tile_size.x, (grid_size.y + 1) * tile_size.y) 
	draw_rect(Rect2(position, size), BG)
	
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
	

func _Grid_Settings(gridsize, color, width, bg):
	self.visible = false
	print('Grid size recebido')
	print('Grid size: %s \nColor: %s \nWidth: %s \n BG: %s' % [gridsize, color, width, bg])
	grid_size = gridsize
	LINE_COLOR = color
	LINE_WIDTH = width
	BG = bg
	_draw()
	self.visible = true


