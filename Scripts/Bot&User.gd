extends Control

onready var botline = $'HBoxContainer/VBoxContainer/Bot/LineEdit'
onready var userline = $'HBoxContainer/VBoxContainer/User/LineEdit'

var fpath = 'res://data/User_Config.json'
var itens = {'UserNick' : '', 'BotToken' : '' }


func _ready():
	check_base_file()


func check_base_file():
	var fpathtest = File.new()
	var ftest
#	var itens = {'UserNick' : userline.txt, 'BotToken' : botline.txt }

	ftest = fpathtest.file_exists(fpath)
	
	if ftest != true:
		print('"User_Config.json" not found \n' + 'Creating "User_Config.json" file')
		creat_file()
	else:
		var f = File.new()
		var content
		var p
		
		print('"User_Config.json" already exists')
		f.open(fpath, File.READ)
		
		content = f.get_as_text()
		content = parse_json(content)
		userline.text = content['UserNick']
		botline.text = content['BotToken']
#		btext.set_text('0000') 
		f.close()
	

func creat_file():
	var f = File.new()
	
	f.open(fpath, File.WRITE)
	f.store_string(to_json(itens))
	print('"User_Config.json" created')
	f.close()


func updating_file():
	var f = File.new()
	var txt
	
	f.open(fpath, File.READ)
	txt = f.get_as_text()
	txt = parse_json(txt)
	
	txt['BotToken'] = botline.text
	txt['UserNick'] = userline.text
	
	f.open(fpath, File.WRITE)
	f.store_string(to_json(txt))
	print('User_config.json updated \n')
	f.close()



func _on_Save_User_Bot_button_up():
	updating_file()
