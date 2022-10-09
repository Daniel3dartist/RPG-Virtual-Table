extends Control

var on_dev_pc = false

signal pass_chat_input(value)
signal pass_roll(value)

var app_username
var request_user

var BASE_PATH = OS.get_executable_path().get_base_dir()

var snum
var sheet_num = 0
var sheet_list = []
var sheet = {
		'Name': '',
		'Number': '',
		'Dir': '',
		'Path': '',
	}

#bot
onready var bot = $'Bot/HTTPRequest'

# Chat
onready var chat = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat'
onready var chat_input = $'Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat_Input'

var character_sheet_path = preload("res://Scenes/Sheet/Character_Sheet.tscn")

onready var sheet_container = $"Base_UI/Chat_&_Rolls_Results/TabContainer/SheetList"
var sheet_call_Hbox = preload('res://Scenes/Table/SheetCallHBox.tscn')
var sheet_call = preload("res://Scenes/Table/SheetCall.tscn")

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
	print("Table self ",self)
	var config = ConfigFile.new()
#	var err = config.load('res://data/last_played.ini')
	var last = ConfigFile.new()
	var sz = 0
	var num
	
	bot.connect("receive_text_from_discord", self, "Receive_Text_from_Discord")
	last.load('%s/data/last_played.ini' % BASE_PATH)
	print(last.get_sections())
	BASE_PATH = last.get_value("Last Played", "Last table")['path']
	print('Self Index ready table: \n', BASE_PATH)
	
	check_exist_file()
	config.load(BASE_PATH)
	for Sheets in config.get_sections():
		sheet_list = config.get_value(Sheets, 'Sheets')
	num = sheet_list.size()
	while num  > sz:
		organize_sheet_list(sz)
		sz += 1 
	chat.append_bbcode('[center]Table Initialized!![/center]\n')
	chat.append_bbcode('[center]Welcome![/center]\n')

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
	
	err = dir.open(BASE_PATH + '/Sheets')
	if err != OK:
		dir.open(BASE_PATH)
		dir.make_dir('Sheets')
	
	err = config.load(BASE_PATH + '/Sheet_List.save')
	if err != OK:
		print('File not found...')
		config.set_value("Sheets", "Sheets", sheet_list)
		config.save(BASE_PATH + '/Sheet_List.save')
	else:
		for Sheets in config.get_sections():
			sheet_list = config.get_value(Sheets, "Sheets")


func _on_Sheet_Creator_button_up():
	Creat_Character_Sheet()


func _on_Sheets_button_up():
	var split_sheet = get_node('Base_UI/Chat_&_Rolls_Results/HBoxContainer/SplitSheetList')
	if split_sheet.visible != true:
		split_sheet.visible = true
	else:
		split_sheet.visible = false


func Creat_Character_Sheet():
	var sheet_box_instance = sheet_call_Hbox.instance()
	var sheet_call_instance = sheet_call.instance()
	var txt = 'Sheet'
	var SPath = '%s/Sheets/Sheet/Sheet' % BASE_PATH
	var dir = Directory.new()
	var Dname = txt
	var Dpath =  '%s/Sheets' % BASE_PATH

	sheet_num = sheet_list.size()
	print(Dpath)
	if sheet_num > 0:
		txt = 'Sheet (%s)' % sheet_num
		Dname = Dname + '(%s)' % sheet_num
		SPath =BASE_PATH + '/Sheets/'+ Dname + '/'+ Dname
		Dpath = Dpath + '/'+ Dname
		print("SPath" ,SPath)

	sheet = {
		'Name': txt,
		'Number': sheet_num,
		'Dir': '%s/Sheets/%s' % [BASE_PATH, Dname],
		'Path': '%s.save' % SPath,
	}
	
	
#	dir.open(Dpath)
#	dir.make_dir(Dname)
	
	dir.open('%s/Sheets/' % BASE_PATH)
	dir.make_dir(Dname)
	
	sheet_list.push_back(sheet)
	sheet_call_instance.text = txt
	sheet_box_instance.add_child(sheet_call_instance)
	sheet_container.add_child(sheet_box_instance)
	sheet_num = sheet_num + 1
	sheet_box_instance.connect('delete_sheet', self, '_Delete_Sheet')
	sheet_call_instance.connect("call_sheet", self, '_Call_Sheet')
	
	var save = ConfigFile.new()
	save.set_value("Sheet", "Name", txt)
	save.save(sheet["Path"])
	print('BASE_PATH: ', BASE_PATH)
	update_list()

func update_list():
	var config = ConfigFile.new()
	var err = config.load(BASE_PATH + '/Sheet_List.save')
	
	if err == OK:
		config.set_value("Sheets", "Sheets", sheet_list)
		config.save(BASE_PATH + '/Sheet_List.save')


func _Call_Sheet(value):
	var csp = character_sheet_path.instance()
#	csp.text = sheet_list[value]['Name']
	snum = value 
	print('num: ', snum)
#	csp.get_node('ColorRect/SheetArea/CharacterBaseArea/CharacterName_BoxC/Character_Name').text = sheet_list[value]['Name']
	csp.connect('give_data', self, '_Give_Data')
	$'Sheet_Spaw'.add_child(csp)
#	emit_signal("receive_sheet_data", sheet_list[snum]['Path'])


func _Give_Data(index):
	print('Give data...')
	emit_signal("receive_sheet_data", sheet_list[snum]['Path'])


func organize_sheet_list(sz):
	var sheet_box_instance = sheet_call_Hbox.instance()
	var sheet_call_instance = sheet_call.instance()
	var txt = 'Sheet'
	var SPath = '%s/Sheet/Sheet' % BASE_PATH
	var Dname = txt

	if sz > 0:
		txt = 'Sheet (%s)' % sheet_num
		Dname = Dname + '(%s)' % sheet_num
		SPath = BASE_PATH + '/'+ Dname + '/'+ Dname
		print('Spath SPath ',SPath)

	sheet = {
		'Name': txt,
		'Number': sheet_num,
		'Path': '%s.save' % SPath,
	}
		
		
	sheet_call_instance.text = txt
	sheet_box_instance.add_child(sheet_call_instance)
	sheet_container.add_child(sheet_box_instance)
	sheet_box_instance.connect('delete_sheet', self, '_Delete_Sheet')
	sheet_call_instance.connect("call_sheet", self, '_Call_Sheet')
	sheet_num += 1


func _on_Main_Menu_button_up():
	var main_menu = 'res://Scenes/Main Menu/Main Menu.tscn' # set main menu path
	get_tree().change_scene(main_menu) # call the main menu scene


func _Delete_Sheet(index):
	var dir = Directory.new()
	var name = sheet_list[index - 1]['Name']
	var remove_path
	
	if " " in name:
		name = name.replace(' ', '')
		remove_path = BASE_PATH + '/Sheets/%s' % name
	else:# sheet_list.size():
		remove_path = BASE_PATH + '/Sheets'
		name = 'Sheet'
	name = '/' + name
	print('Sheet_List: ', sheet_list[index - 1])
	print('Name dir: ', BASE_PATH + '/Sheets/%s' % name)
	dir.open(BASE_PATH + '/Sheets')
	dir.remove(BASE_PATH + '/Sheets%s.save' % name.repeat(2))
	dir.remove(BASE_PATH + '/Sheets%s' % name)
	print('delete sheet ')
	
	sheet_list.remove(index - 1)
	print('BASE_PATH: ', BASE_PATH)
	print('BASE_PATH + name: ', BASE_PATH + '/Sheets/%s' % name)
	print('Index - 1: ', index - 1)
	update_list()


func update_grid():
		emit_signal("grid_settings", Vector2(int(grid_VX.text), int(grid_VY.text)), line_color_pick.color, int(line_size.text), bg_color_pick.color)


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
	if on_dev_pc == true:
		path = 'res://data/user_settings.ini'
	else:
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
