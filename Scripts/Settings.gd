extends Control

var fpath = 'res://Saves_Teste/settings.json'

var types_of_windows_modes = ['Window', 'Full Screen', 'Borderless Window']
var resolutions = ['640 x 480', '800 x 600', '1024 x 768', '1152 x 864','1280 x 720', '1280 x 800', '1280 x 1024', '1366 x 768', '1440 x 900', '1600 x 900', '1680 x 1050', '1920 x 1080', '2560 x 1440', '2048 x 1080', '3840 x 2160', '7680 x 4320']
var tkey 
var rkey
var settings_keys
# Windows modes label
onready var windowsl = $'VBoxContainer/VBoxContainer/Window Mode_Container/HBoxContainer/Label2'
# Resolutions label
onready var resolutionsl = $'VBoxContainer/VBoxContainer/Resolution_Container/HBoxContainer/Label2'


func _ready():
	check_settings_file()


func check_settings_file():
	var fpathtest = File.new()
	var ftest
	var f
	var content
	
	ftest = fpathtest.file_exists(fpath)
	if ftest != true:
		print('Creating a new settings file ')
		fpathtest.close()
		creat_file()
	else:
		print('Settings file allready exists')
		f = File.new()
		f.open(fpath, File.READ)
		content = f.get_as_text()
		content = parse_json(content)
		tkey = int(content[0])
		rkey = int(content[1])
		windowsl = types_of_windows_modes[tkey]
		resolutionsl = resolutions[rkey]
		f.close()


# Window modes
func _on_WBack_button_up():
	var tscreen = types_of_windows_modes
	var k = types_of_windows_modes[tkey]
	
	print(types_of_windows_modes[tkey])
	if k != types_of_windows_modes[0]:
		tkey = tkey - 1
		windowsl.text = str(tscreen[tkey])
		print(str(tkey))
	else:
		tkey = 2
		print(tkey)
		windowsl.text = tscreen[tkey]
		print(tscreen[tkey])


func _on_WFront_button_up():
	var tscreen = types_of_windows_modes
	var k = types_of_windows_modes[tkey]
	
	print(types_of_windows_modes[tkey])
	if k != types_of_windows_modes[2]:
		tkey = tkey + 1
		windowsl.text = tscreen[tkey]
		print(str(tkey))
	else:
		tkey = 0
		print(tkey)
		windowsl.text = tscreen[tkey]
		print(tscreen[tkey])

# Resolutions
func _on_RBack_button_up():
	pass # Replace with function body.


func _on_RFront_button_up():
	pass # Replace with function body.

# Save Settings
func _on_Save_Settings_button_up():
	var f = File.new()
	var txt
	
	f.open(fpath, File.READ)
	txt = f.get_as_text()
	txt = parse_json(txt)
	
	txt[0] = tkey
	txt[1] = rkey
	print('Esse é o TXT com a mudança das Keys: ', txt)
	
	f.open(fpath, File.WRITE)
	f.store_string(to_json(txt))
	print('User_config.json updated \n', 'The new string is: ', txt, '\n')
	f.close()

# Restore Settings
func _on_Restore_button_up():
	pass # Replace with function body.


func creat_file():
	var f = File.new()
	
	settings_keys = [1, 4]
	f.open(fpath, File.WRITE)
	f.store_string(to_json(settings_keys))
	print('"settings.json" created')
	f.close()
