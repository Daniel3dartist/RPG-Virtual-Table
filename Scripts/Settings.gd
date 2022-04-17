extends Control

var fpath = 'res://Saves_Teste/Settings.json'

var types_of_windows_modes = ['Window', 'Full Screen', 'Borderless Window']
var resolutions = ['640 x 480', '800 x 600', '1024 x 768', '1152 x 864','1280 x 720', '1280 x 800', '1280 x 1024', '1366 x 768', '1440 x 900', '1600 x 900', '1680 x 1050', '1920 x 1080', '2560 x 1440', '2048 x 1080', '3840 x 2160', '7680 x 4320']

var tkey 
var rkey
var settings_keys
var t
var reskey
var xy
var vx 
var vy

# Windows modes label
onready var windowsl = $'VBoxContainer/VBoxContainer/Window Mode_Container/HBoxContainer/Label2'
# Resolutions label
onready var resolutionsl = $'VBoxContainer/VBoxContainer/Resolution_Container/HBoxContainer/Label2'
# Timer Node
onready var timer = $'Timer'
# Countdown Lalbel Popup
onready var count = $"PopupMenu/VBoxContainer/Countdown"
# Popup node
onready var popup = $'PopupMenu'


func _ready():
	check_settings_file()
	timer.set_wait_time(15)


func _process(delta):
	if t == true:
		timer.set_one_shot(true)
		count.text = str(int(timer.get_time_left()))
		popup.visible = true
#		print(count.text)
	if int(timer.get_time_left()) == 0 and t == true:
		print('Acabou o tempo')
		popup.visible = false
		restore()
		timer.stop()
		t = false


func check_settings_file():
	var fpathtest = File.new()
	var ftest
	var f
	var content

	ftest = fpathtest.file_exists(fpath)

	if ftest != true:
		print('Creating a new settings file ')
		fpathtest.close()
		tkey = 1
		rkey = 4
		windowsl.text = types_of_windows_modes[tkey]
		resolutionsl.text = resolutions[rkey]
		creat_file()
		windows_mod()
	else:
		print('Settings file allready exists')
		f = File.new()
		f.open(fpath, File.READ)
		content = f.get_as_text()
		content = parse_json(content)
		print('Esse é o content: ' + str(content[1]))
		tkey = int(content[0])
		rkey = int(content[1])
		windowsl.text = types_of_windows_modes[tkey]
		resolutionsl.text = resolutions[rkey]
		f.close()

		xy = resolutions[int(content[1])].split('x')
		vx = xy[0]
		vy = xy[1]
		OS.window_size = Vector2(vx, vy)
		
		windows_mod()


# Window modes
func _on_WBack_button_up():
	var twindow = types_of_windows_modes
	var k = types_of_windows_modes[tkey]
	
	print(types_of_windows_modes[tkey])
	if k != types_of_windows_modes[0]:
		tkey = tkey - 1
		windowsl.text = str(twindow[tkey])
		print(str(tkey))
	else:
		tkey = -1
		print(tkey)
		windowsl.text = twindow[tkey]
		print(twindow[tkey])


func _on_WFront_button_up():
	var twindow = types_of_windows_modes
	var k = types_of_windows_modes[tkey]
	
	print(k)
	if k != types_of_windows_modes[-1]:
		tkey = tkey + 1
		windowsl.text = twindow[tkey]
		print(str(tkey))
	else:
		tkey = 0
		print(tkey)
		windowsl.text = twindow[tkey]
		print(twindow[tkey])


# Resolutions
func _on_RBack_button_up():
	var screen = resolutions
	var k = resolutions[rkey]
	
	print('Essa é a lista de keys: ' + str(screen.size()))
	
	print(k)
	if k != resolutions[0]:
		rkey = rkey - 1
		resolutionsl.text = screen[rkey]
		print(screen[rkey])
	else:
		rkey = -1
		resolutionsl.text = screen[rkey]
		print("Rkey é " + str(rkey))
		print("Resolutions.text é: " + resolutionsl.text)


func _on_RFront_button_up():
	var screen = resolutions
	var k = resolutions[rkey]
	
	print('Essa é a lista de keys: ' + str(screen.size()))
	
	print(k)
	if k != resolutions[-1]:
		rkey = rkey + 1
		resolutionsl.text = screen[rkey]
		print(screen[rkey])
	else:
		rkey = 0
		resolutionsl.text = screen[rkey]
		print("Rkey é " + str(rkey))
		print("Resolutions.text é: " + resolutionsl.text)


# Save Settings
func _on_Save_Settings_button_up():
	xy = resolutions[rkey].split('x')
	vx = int(xy[0])
	vy = int(xy[1])
	
	t = true
	timer.start()
	OS.window_size = Vector2(vx, vy)
	windows_mod()

# Restore Settings
func _on_Restore_button_up():
	restore()
	
	t = false
	timer.stop()
	popup.visible = false
	
	windows_mod()


func creat_file():
	var f = File.new()
	
	settings_keys = [1, 4]
	f.open(fpath, File.WRITE)
	f.store_string(to_json(settings_keys))
	print('"settings.json" created')
	f.close()


func _on_Accepted_button_up():
	t = false
	timer.stop()
	popup.visible = false
	save()
	windows_mod()


func _on_Restore_Last_button_up():
	check_settings_file()
	t = false
	timer.stop()
	popup.visible = false


func save():
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
	


func restore():
	xy = resolutions[4].split('x')
	vx = int(xy[0])
	vy = int(xy[1])
	
	OS.window_size = Vector2(vx, vy)
	windowsl.text = types_of_windows_modes[0]
	resolutionsl.text = resolutions[4]
	tkey = 0
	rkey = 4
	save()

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

