extends Control

var on_dev_pc = false
var fpath = 'res://data/Settings.json'

var tkey 
var rkey 

var xy 
var vx 
var vy 

var types_of_windows_modes = ['Window', 'Full Screen', 'Borderless Window']
var resolutions = ['640 x 480', '800 x 600', '1024 x 768', '1152 x 864','1280 x 720', '1280 x 800', '1280 x 1024', '1366 x 768', '1440 x 900', '1600 x 900', '1680 x 1050', '1920 x 1080', '2560 x 1440', '2048 x 1080', '3840 x 2160', '7680 x 4320']

var next_scene = 'res://Scenes/Table.tscn'
var load_table_menu = 'res://Scenes/Load Table Menu.tscn'

var settings_menu = 'res://Scenes/Settings.tscn'

func _ready():
	creat_directory()
	check_settings_file()

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
	
	dirpathtest = dirpathtest.open('res://data/')
	dirs = str(dirpathtest)
	
	if dirpathtest != OK:
		var drr 
		var rdir = Directory.new()
		
		if on_dev_pc == true:
			drr = 'res://'
			print('This is the drr dir: ' + drr + '\n' + 'on_dev_pc == true')
		else:
			drr = OS.get_executable_path().get_base_dir()
			print('This is the drr dir: ' + drr + '\n' + 'on_dev_pc == false')

		print(rdir)
		rdir.open(str(drr))
		print(rdir)
		rdir.make_dir('data')
		print(rdir)
		print('Novo dir foi criado!' + str(rdir.get_current_dir( )))
		print('Novo dir foi criado!' + str(OS.get_user_data_dir( )))
		print('Novo dir foi criado! \n' + 'New dir path: ' + drr)
	else:
		print('Dir data exist!')


func check_settings_file():
	var fpathtest = File.new()
	var ftest
	var f
	var content

	ftest = fpathtest.file_exists(fpath)
	if ftest == true:
		f = File.new()
		print('Settings file allready exists')
		
		f.open(fpath, File.READ)
		content = f.get_as_text()
		content = parse_json(content)
	#	print('Esse é o content: ' + str(content[1]))
		tkey = int(content[0])
		rkey = int(content[1])
		f.close()

		xy = resolutions[int(content[1])].split('x')
		vx = xy[0]
		vy = xy[1]
		OS.window_size = Vector2(vx, vy)

		windows_mod()



func windows_mod():
	var window = types_of_windows_modes[tkey]
	
	if window == 'Window':
		OS.window_fullscreen = false
		OS.window_borderless = false
		OS.window_maximized = false

	elif window == 'Full Screen':
		OS.window_fullscreen = true
		OS.window_borderless = false
		OS.window_maximized = false
		
	elif window == 'Borderless Window':
		OS.window_fullscreen = false
		OS.window_borderless = true
		OS.window_maximized = true
