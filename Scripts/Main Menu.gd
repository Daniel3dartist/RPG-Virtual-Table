extends Control

var next_scene = 'res://Scenes/Table.tscn'
var load_table_menu = 'res://Scenes/Load Table Menu.tscn'

var settings_menu = 'res://Scenes/Settings.tscn'

func _ready():
	creat_directory()

# Quit the APP from Main Menu
func _on_Exit_button_up():
	get_tree().quit()

# Load last table
func _on_Continue_button_up():
	get_tree().change_scene(next_scene)


func _on_Load_table_button_up():
	get_tree().change_scene(load_table_menu)


func _on_Settings_button_up():
	get_tree().change_scene(settings_menu)

func creat_directory():
	var dirs
	var dirpathtest = Directory.new()
	
	print('Verificando se tem o diretorio de salvamento!')
	
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
