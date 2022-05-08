extends Control


var fpath = "res://data/Settings.cfg"

var types_of_windows_modes = ["Window", "Full Screen", "Borderless Window"]
var resolutions = ["640 x 480", "800 x 600", "1024 x 768", "1152 x 864", "1280 x 720", "1280 x 800", "1280 x 1024", "1366 x 768", "1440 x 900", "1600 x 900", "1680 x 1050", "1920 x 1080", "2560 x 1440", "2048 x 1080", "3840 x 2160", "7680 x 4320"]

var d

var Wkey 
var Rkey
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
	popup.visible = false


func _process(delta):
	if t == true:
		timer.set_one_shot(true)
		count.text = str(int(timer.get_time_left()))
		popup.visible = true
	if int(timer.get_time_left()) == 0 and t == true:
		popup.visible = false
		restore()
		timer.stop()
		t = false


func check_settings_file():
	var config = ConfigFile.new()
	var ftest = File.new()
	var err = config.load(fpath)
	
	if err != OK:
		print('Erro ao ler arquivo')
		ftest = ftest.file_exists(fpath)
		if ftest != true:
			config.set_value("Video", "Window", "Window")
			config.set_value("Video", "Resolution", "1280 x 720")
			config.save(fpath)

	for Video in config.get_sections():
		Wkey = config.get_value(Video, "Window")
		Rkey = config.get_value(Video, "Resolution")

	windowsl.text = Wkey
	resolutionsl.text = Rkey
	xy = Rkey.split('x')
	vx = int(xy[0])
	vy = int(xy[1])
	OS.window_size = Vector2(vx, vy)
	print(Wkey, Rkey)
	windows_mod()

# Window modes
func _on_WBack_button_up():
	var twindow = types_of_windows_modes
	var k = twindow.find(Wkey)
	var sz = twindow.size() - 1
	var w
	
	print(twindow.size())
	if k <= sz:
		k -= 1
		w = twindow[k]
		Wkey = w
		windowsl.text = w
		print(k)
	else:
		k = sz
		w = twindow[k]
		Wkey = w
		windowsl.text = w


func _on_WFront_button_up():
	var twindow = types_of_windows_modes
	var k = twindow.find(Wkey)
	var sz = twindow.size() - 1
	var w

	if k < sz:
		k += 1
		w = twindow[k]
		Wkey = w
		windowsl.text = w
		print(k)
	else:
		k = 0
		w = twindow[k]
		Wkey = w
		windowsl.text = w
		print(k)

# Resolutions
func _on_RBack_button_up():
	var screen = resolutions
	var k = screen.find(Rkey)
	var sz = screen.size() - 1
	var r

	if k > 0:
		k -= 1
		r = screen[k]
		Rkey = r
		resolutionsl.text = r
	else:
		k = -1
		r = screen[k]
		Rkey = r
		resolutionsl.text = r


func _on_RFront_button_up():
	var screen = resolutions
	var k = screen.find(Rkey)
	var sz = screen.size() - 1
	var r

	if k != sz:
		k = k + 1
		r = screen[k]
		Rkey = r
		resolutionsl.text = r
	else:
		k = 0
		r = screen[k]
		Rkey = r
		resolutionsl.text = r

# Save Settings
func _on_Save_Settings_button_up():
	xy = Rkey.split('x')
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
	var config = ConfigFile.new()
	
	config.set_value("Video", "Window", Wkey)
	config.set_value("Video", "Resolution", Rkey)
	config.save(fpath)


func restore():
	Wkey = 'Window'
	Rkey = '1280 x 720'
	
	xy = Rkey.split('x')
	vx = int(xy[0])
	vy = int(xy[1])
	
	OS.window_size = Vector2(vx, vy)
	windows_mod()
	windowsl.text = Wkey
	resolutionsl.text = Rkey
	save()

func windows_mod():
	var window = Wkey
	
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

