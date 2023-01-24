extends Control

signal is_dir(value)

var on_dev_pc = false
var BASE_PATH = OS.get_executable_path().get_base_dir() + '/data/settings.ini'

var next_scene = 'res://Scenes/Table/Table.tscn'

var load_table_menu = 'res://Scenes/Load Table/Load Table Menu.tscn'

var settings_menu = 'res://Scenes/Settings/Settings.tscn'

func _ready():
	print('Initializing...')
	creat_directory()
	check_settings_file()

# Quit the APP from Main Menu
func _on_Exit_button_up():
	get_tree().quit()
	

# Load last table
func _on_Continue_button_up():
	var config = ConfigFile.new()
	var err = config.load('%s/data/last_played.ini' % OS.get_executable_path().get_base_dir())
	
	if err != OK or config.get_value("Last Played", "Last table") == null:
		get_tree().change_scene(load_table_menu)
	else:
		print('Not null')
		get_tree().change_scene(next_scene)



func _on_Load_table_button_up():
	get_tree().change_scene(load_table_menu)


func _on_Settings_button_up():
	get_tree().change_scene(settings_menu)

func creat_directory():
	var drr
	var dirs
	var dirpathtest = Directory.new()
	
	print('\nChecking if a save directory exists...\n')

	if on_dev_pc == true:
		drr = 'res://'
		print('This is the drr dir: ' + drr + '\n' + 'on_dev_pc == true')
	else:
		drr = OS.get_executable_path().get_base_dir()
		print('This is the drr dir: ' + drr + '\n' + 'on_dev_pc == false')


	dirpathtest = dirpathtest.open('res://data/')
	dirs = str(dirpathtest)
	
	if dirpathtest != OK:
		var rdir = Directory.new()

		print(rdir)
		rdir.open(str(drr))
		print(rdir)
		rdir.make_dir('data')
		print(rdir)
		print('Novo dir foi criado!' + str(rdir.get_current_dir( )))
		print('Novo dir foi criado!' + str(OS.get_user_data_dir( )))
		print('Novo dir foi criado! \n' + 'New dir path: ' + drr)
		dirs = drr
	else:
		print('Dir data exist!')
	
	var sheets = Directory.new()
	var Sdir = Directory.new()
#	print('SHeeeeet: ',sheets.open(drr.insert(-1, '/data')))
	Sdir = Sdir.open('%sdata/Tables' % drr)
	if Sdir != OK:
		sheets.open('%sdata' % drr)
		sheets.make_dir('Tables')
	emit_signal("is_dir", true)

func check_settings_file():
	var config = ConfigFile.new()
	var err
	var window 
	var resolution


	err = config.load(BASE_PATH)
	if err != OK:
		print("Settings file is missing")
	else:
		for Video in config.get_sections():
			window = config.get_value(Video, "Window")
			resolution = config.get_value(Video, "Resolution")
	
		resolution = resolution.split('x')
		OS.window_size = Vector2(resolution[0], resolution[1])

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
		print('Window: %s \n'% window,'Resolution: %s\n' % resolution )
