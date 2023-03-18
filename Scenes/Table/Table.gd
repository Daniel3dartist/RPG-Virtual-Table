extends Control

signal pass_chat_input(value)
signal pass_roll(value)
signal on_table(value)
signal index(value)

var app_username
var request_user

var BASE_PATH = OS.get_executable_path().get_base_dir() + '/data/Tables'

var snum
var sheet_num = 0
var sheet_list : Array = []

#bot
onready var bot = $'Bot/HTTPRequest'

# Chat
onready var chat = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat'
onready var chat_input = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat_Input'

var character_sheet_path

onready var sheet_container = $"Base_UI/Chat_&_Rolls_Results/TabContainer/SheetList/ScrollContainer/VBoxContainer"
var sheet_call_Hbox = preload('res://Scenes/Table/SheetCallHBox.tscn')

# Grid settings
# Grid size - vector x input
onready var grid_VX = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Settings/VBoxContainer/CenterContainer/LineEdit'
# Grid size - vector y input
onready var grid_VY = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Settings/VBoxContainer/CenterContainer2/LineEdit'
# Grid line color pick
onready var line_color_pick = $"Base_UI/Chat_&_Rolls_Results/TabContainer/Settings/VBoxContainer/CenterContainer3/LineColor"
# BG color pick
onready var bg_color_pick = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Settings/VBoxContainer/CenterContainer4/BGColor'
# Line size input
onready var line_size = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Settings/VBoxContainer/CenterContainer5/LineEdit'


# signals
signal receive_sheet_data(data_path)
signal grid_settings(gridsize, color, width, bg)

# Functions
func _ready():
	get_self_username()
	var path = OS.get_executable_path().get_base_dir() + '/data/last_played.ini'  
	var config = ConfigFile.new()
	var config2 = ConfigFile.new()
#	var err = config.load('res://data/last_played.ini')
	var last = ConfigFile.new()
	var num = 0
	config.load(path)
	config2.load(config.get_value('Last Played', 'path'))
	var _name = config2.get_value('Table', 'name')
	print('\n\n_NAME: ', _name, '\n\n')
	$'table_name'.text = _name
	
	var system = config.get_value('Last Played', 'system')
	print('\n\n',system, '\n\n')
	var item_path : Array
	match system:
		'Dungeons & Dragons - 5E':
			item_path = ['Dungeons_&_Dragons_5E', 'D&D5TH_Character_Sheet']
		'Forbidden Lands':
			print('\n\nforbidden\n\n')
			item_path = ['Forbidden_Lands', 'ForbiddenLands_Character_Sheet']
		'Tormenta RPG':
			item_path = ['Dungeons_&_Dragons_5E', 'D&D5TH_Character_Sheet'] # Just for testing ( change later )
		'Pathfinder':
			item_path = ['Dungeons_&_Dragons_5E', 'D&D5TH_Character_Sheet'] # Just for testing ( change later )
		'Pathfinder 2.0':
			item_path = ['Dungeons_&_Dragons_5E', 'D&D5TH_Character_Sheet'] # Just for testing ( change later )
		'...':
			item_path = ['Dungeons_&_Dragons_5E', 'D&D5TH_Character_Sheet'] # Just for testing ( change later )
	character_sheet_path = "res://Scenes/Sheet/%s/%s.tscn" % item_path

	if config2.get_value('Table', 'sheets') != null:
		sheet_list = config2.get_value('Table', 'sheets')
		for i in sheet_list:
			var buttom = sheet_call_Hbox.instance()
			sheet_container.add_child(buttom)
			sheet_container.get_child(num).get_node('Sheet').text = sheet_list[num]['name']
			sheet_container.get_child(num).get_node('path').text = sheet_list[num]['path']
			print('\n\nIs Child: %s\n\n' % sheet_container.get_child(num).get_node('Sheet').text)
			buttom.connect('delete_sheet', self, '_Delete_Sheet')
			buttom.connect("call_sheet", self, '_Call_Sheet')
			buttom.connect("update_sheet_buttom", self, '_Update_Sheet_Buttom')
			sheet_num += 1
			num += 1
	check_exist_file()
	
	chat.append_bbcode('[center]Table Initialized!![/center]\n')
	chat.append_bbcode('[center]Welcome![/center]\n')
	emit_signal('on_table', true)

func _input(event):
	var user_color = '#6eff90'
	var result
	
	if self.get_node('Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput').visible == true:
		if chat_input.text != '' and chat_input.text != ' ' and Input.is_action_just_pressed("enter"):
			var roll = chat_input.text
			request_user = '[color=%s]%s[/color]' % [user_color , app_username]
			var txt = '[color=%s]%s[/color]: %s\n' % [user_color, app_username, chat_input.text]
			pass_input(chat_input.text)
#			chat.append_bbcode(txt)
			if '/r' in roll:
				if 'd3' in roll:
					print('\n\n\n /rd3\n\n\n')
					result = rolld3()
				elif 'd4' in roll:
					result = rolld4()
				elif 'd6' in roll:
					result = rolld6()
				elif 'd8' in roll:
					result = rolld8()
				elif 'd10' in roll:
					result = rolld10()
				elif '12' in roll:
					result = rolld12()
				elif '20' in roll:
					result = rolld20()
				elif '100' in roll:
					chat.append_bbcode(rolld100())
			if result != null:
				chat.append_bbcode(txt + result)
			else:
				chat.append_bbcode(txt)
		elif Input.is_action_just_released("enter"):
			chat_input.text = ''

func check_exist_file():
	var config = ConfigFile.new() 
	var err 
	var dir = Directory.new()
	var _name = self.get_node("table_name").text
	

	err = dir.open(BASE_PATH + '/%s/Sheets' %  _name)
	if err != OK:
		dir.open(BASE_PATH + '/%s' % _name)
		dir.make_dir('Sheets')
	
	err = config.load(BASE_PATH + '/%s/%s.ini' % [_name, _name])
	if err == null:
		print('File not found... ', _name)
		_Save_Table()
		print('File Created...')
	else:
		err = null
		print('Has File...\n')
		pass

func _Save_Table():
	var config = ConfigFile.new()
	var _name = self.get_node("table_name").text
	
	config.load(BASE_PATH + '/%s/%s.ini' % [_name, _name])
#	sheet_list = config.get_value('Table', 'sheets')
	config.set_value('Table', 'name', _name)
	config.set_value('Table', 'sheets', sheet_list)
	config.set_value('Layers', 'layers_list', sheet_list)
	config.set_value('Grid', 'grid', '')
	config.set_value('Grid', 'tokens', '')
	config.save(BASE_PATH + '/%s/%s.ini' % [_name, _name])
	print('\n\nDone...\n\n %s \n\n' % (BASE_PATH + '/%s/%s.ini' % [_name, _name]))
	

func _on_Sheet_Creator_button_up():
	Creat_Character_Sheet()
#	_Save_Table()
	print('TName: ', $'table_name'.text)


func _on_Sheets_button_up():
	var split_sheet = get_node('Base_UI/Chat_&_Rolls_Results/HBoxContainer/SplitSheetList')
	if split_sheet.visible != true:
		split_sheet.visible = true
	else:
		split_sheet.visible = false

func _Update_Sheet_Buttom(array):
	var id = array[0]
	var item = sheet_list[id]

	sheet_list[id]['name'] = array[1]
	sheet_list[id]['path'] = array[3]
	_Save_Table()

func Creat_Character_Sheet():
	var sheet_box_instance = sheet_call_Hbox.instance()
#	var sheet_call_instance = sheet_call.instance()
	var txt = 'Sheet'
	var SPath = '%s/%s/Sheets/Sheet/Sheet.save' % [BASE_PATH, $'table_name'.text]
	var dir = Directory.new()
	var cfg = ConfigFile.new()
	var Dname = txt
	var Dpath =  '%s/%s/Sheets/%s' % [BASE_PATH, $'table_name'.text, txt]
	var sheet = {
		'name': '',
		'num': '',
		'path': '',
	}

	sheet_num = sheet_container.get_child_count()
	print(Dpath)
	if sheet_num > 0:
		txt = 'Sheet (%s)' % sheet_num
		Dname = Dname + '(%s)' % sheet_num
		SPath = '%s/%s/Sheets/%s/%s.save' % [BASE_PATH, $'table_name'.text,  txt.replace(' ', ''), txt]
		Dpath =  '%s/%s/Sheets/%s' % [BASE_PATH, $'table_name'.text, txt.replace(' ', '')]
		print("SPath" ,SPath, '\n\n%s\n\n' % dir.dir_exists(Dpath))
	print("SPath" ,Dpath, '\n\n%s\n\n' % dir.dir_exists(Dpath))
	if dir.dir_exists(Dpath) == false:
		dir.make_dir(Dpath)
	if dir.file_exists(SPath) == false:
		cfg.save(SPath)
	sheet_container.add_child(sheet_box_instance)
	sheet_container.get_child(sheet_num).get_node('Sheet').text = txt
	sheet_container.get_child(sheet_num).get_node('path').text  = SPath
	sheet['name'] = txt
	sheet['num'] = sheet_num
	sheet['path'] = SPath
	print('Sheet dict? ', sheet_list)
	sheet_list.push_back(sheet)
	sheet_num =+ 1 
	sheet_box_instance.connect('delete_sheet', self, '_Delete_Sheet')
	sheet_box_instance.connect("call_sheet", self, '_Call_Sheet')
	sheet_box_instance.connect("update_sheet_buttom", self, '_Update_Sheet_Buttom')
	
	_Save_Table()

var sheet_dic : Dictionary = {
	'name': '',
	'path': '',
	'data': '',
}
func _Call_Sheet(value):
	print('Value: ', value)
	var packed_scene = load(character_sheet_path)
	var _name = value['name']
# Instance the scene
	var my_scene = packed_scene.instance()
	my_scene.get_node('path').text = value['path']
	my_scene.get_node('Panel/SheetArea/Sheet_TabContainer/Main/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/CharacterBaseArea/CharacterName_BoxC/Character_Name').text = value['name']
	$'Sheet_Spaw'.add_child(my_scene)
	my_scene.connect('Save_sheet_path', self, '_UpDate_Sheet_List')

	
	emit_signal('receive_sheet_data', value)

func _Give_Data(index):
	print('Giving data...')
	emit_signal('receive_sheet_data', sheet_dic)


func _UpDate_Sheet_List(array):
	print('\n\n Array received\n\n')
	sheet_list = array


func _on_Main_Menu_button_up():
	var main_menu = 'res://Scenes/Main Menu/Main Menu.tscn' # set main menu path
#	_Save_Table()
	get_tree().change_scene(main_menu) # call the main menu scene


func update_grid():
		emit_signal("grid_settings", Vector2(int(grid_VX.text), int(grid_VY.text)), line_color_pick.color, int(line_size.text), bg_color_pick.color)
		_Save_Table()

func _on_LineEdit_text_entered(new_text):
	print('text change')
	update_grid()


func _on_LineColor_popup_closed():
	update_grid()


func _on_BGColor_popup_closed():
	update_grid()

########################################## [ Data HTTP Functions ] ##########################################

# Input received data from Discord
func Receive_Text_from_Discord(value):
	var username
	var user_color = '#52e7f7'
	var text
	var tokens
	var content# =  '[color=]%s[/color]: %s\n' % value
	var txt = value
	
	print("\nValue receive from discord \n", value,'\n')
	if "<username>" in value and "</username>" in value:
		var user_ = value.find_last('<username>')
		var _user = value.find_last('</username>')
		var user_leng
		user_ += '<username>'.length()
		user_leng = _user - user_
		username = value.substr(user_, user_leng)
	if "<text>" in value and "</text>" in value:
		var text_ = value.find_last('<text>')
		var _text = value.find_last('</text>')
		var text_leng
		text_ += '<text>'.length()
		text_leng = _text - text_
		text = value.substr(text_ , text_leng)
	
	content = "[color=%s]%s[/color]: %s\n" % [user_color , username, text]
	chat.append_bbcode(content)

	if '/r' in txt:
		var roll
		request_user = '[color=%s]%s[/color]' % [user_color , username]
		if 'd3' in txt:
			roll = rolld3()
			chat.append_bbcode(roll)
		elif 'd4' in txt:
			roll = rolld4()
			chat.append_bbcode(roll)
		elif 'd6' in txt:
			roll = rolld6()
			chat.append_bbcode(roll)
		elif 'd8' in txt:
			roll = rolld8()
			chat.append_bbcode(roll)
		elif 'd10' in txt:
			roll = rolld10()
			chat.append_bbcode(roll)
		elif 'd12' in txt:
			roll = rolld12()
			chat.append_bbcode(roll)
		elif 'd20' in txt:
			roll = rolld20()
			chat.append_bbcode(roll)
		elif 'd100' in txt:
			roll = rolld100()
			chat.append_bbcode(roll)
		pass_roll(roll)
	
# Get self username from local data
func get_self_username():
	var config = ConfigFile.new()
	var path
	path = OS.get_executable_path().get_base_dir() + '/data/user_settings.ini'
	print(path)
	config.load(path)
	app_username = config.get_value("User", "Nickname")

# Parse string to HTTP bot for Discord
func pass_input(value):
	var txt_parse = '<username>%s</username><text>%s</text>' % [app_username , value]
	emit_signal("pass_chat_input", txt_parse)

func pass_roll(value):
	emit_signal("pass_roll", value)


func _Delete_Sheet(id, _name):
	var cfg = ConfigFile.new()
	var dir = Directory.new()
	cfg.load(OS.get_executable_path().get_base_dir() + '/data/last_played.ini')
	var path =  cfg.get_value("Last Played", "path")
	cfg.load(path)
	var list = cfg.get_value('Table', 'sheets')
#	for i in list:
#		if list[i]['name'] == _name:
	var dir_path = list[id]['path']
	dir_path = dir_path.split('/')
	dir_path.remove(-1)
	dir_path = dir_path.join('/')
	dir.remove(dir_path+'/char_image.png')
	dir.remove(list[id]['path'])
	dir.remove(dir_path)
	list.remove(id)
	sheet_list = list
	_Save_Table()

########################################## [ Roll Dice Functions ] ##########################################

var success = '#14fa33'
var fail = '#f73325'
func rolld3():
	var roll 
	roll = randi() % 3 + 1
	if roll == 3:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D3 = %s\n' % roll
#	chat.append_bbcode('%s \nRoll D3 = %s\n' % [request_user , roll])

func rolld4():
	var roll 
	roll = randi() % 4 + 1
	if roll == 4:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D4 = %s\n' % roll
#	chat.append_bbcode('%s \nRoll D4 = %s\n' % [request_user , roll])

func rolld6():
	var roll 
	roll = randi() % 6 + 1
	if roll == 6:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D6 = %s\n' % roll
#	chat.append_bbcode('%s: \nRoll D6 = %s\n' % [request_user , roll])

func rolld8():
	var roll 
	roll = randi() % 8 + 1
	if roll == 8:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D8 = %s\n' % roll
#	chat.append_bbcode('%s: \nRoll D8 = %s\n' % [request_user , roll])

func rolld10():
	var roll 
	roll = randi() % 10 + 1
	if roll == 10:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D10 = %s\n' % roll
#	chat.append_bbcode('%s \nRoll D10 = %s\n' % [request_user , roll])

func rolld12():
	var roll 
	roll = randi() % 12 + 1
	if roll == 12:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D12 = %s\n' % roll
#	chat.append_bbcode('%s: \nRoll D12 = %s\n' % [request_user , roll])

func rolld20():
	var roll 
	roll = randi() % 20 + 1
	if roll == 20:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D20 = %s\n' % roll
#	chat.append_bbcode('%s: \nRoll D20 = %s\n' % [request_user , roll])

func rolld100():
	var roll 
	roll = randi() % 100 + 1
	if roll == 100:
		roll = '[color=%s]%s[/color]' % [success, roll]
	elif roll == 1:
		roll = '[color=%s]%s[/color]' % [fail, roll]
	return 'Roll D100 = %s\n' % roll
#	chat.append_bbcode('%s: \nRoll D100 = %s\n'  % [request_user , roll])


func _on_d3_b_pressed():
	var roll = rolld3()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)


func _on_d4_b_pressed():
	var roll = rolld4()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)


func _on_d6_b_pressed():
	var roll = rolld6()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)

func _on_d8_b_pressed():
	var roll = rolld6()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)

func _on_d10_b_pressed():
	var roll = rolld10()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)

func _on_d12_b_pressed():
	var roll = rolld12()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)

func _on_d20_b_pressed():
	var roll = rolld20()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)

func _on_d100_b_pressed():
	var roll = rolld100()
	request_user = '[color=#6eff90]%s[/color]' % app_username
	chat.append_bbcode('%s: %s' % [request_user, roll])
	pass_input(roll)


func _on_Settings_button_up():
	get_node('Settings/Settings2').visible = true
