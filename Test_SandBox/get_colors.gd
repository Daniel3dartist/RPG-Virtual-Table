extends Control

var PATH = 'res://Test_SandBox/colors.txt'


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open(PATH, File.READ)
	var colors = file.get_as_text()
	colors = colors.replace(' ', '')
	colors = colors.replace('\n', '')
	colors = colors.split('=')
	print(colors.size(),'\n\n', colors)
	file.close()
	var config = ConfigFile.new()
	config.set_value('Colors', 'colors', colors)
	config.save('res://Scenes/Load Table/Color_list.ini')
	file.open('res://Scenes/Load Table/Color_list.json', File.WRITE)
	file.store_var(to_json(colors))
	file.close()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
