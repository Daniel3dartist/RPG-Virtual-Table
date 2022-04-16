extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Button_button_up():
	save()

func save():
	creat_directory()

func creat_directory():
	var dirs
	var dirpathtest = Directory.new()
	
	dirpathtest = dirpathtest.open('res://Saves_Teste/')
	dirs = str(dirpathtest)
	
	if dirpathtest != OK:
		var rdir = Directory.new()
		print(rdir)
		rdir.open('res://')
		print(rdir)
		rdir.make_dir('Saves_Teste')
		print(rdir)
		print('Novo dir foi criado!')
	else:
		print('Dir saves exist!')


