extends VBoxContainer



func _ready():
#	showdir()
	OS.shell_open('file://')
	
func showdir():
	var path = 'file://'
	var label = Label.new()
	var dir = Directory.new()
	var list = []
	dir.get_dir_contents('file://')
	list.append()
	print(list)
