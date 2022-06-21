extends Control

onready var botline = $'HBoxContainer/VBoxContainer/Bot/LineEdit'
onready var userline = $'HBoxContainer/VBoxContainer/User/LineEdit'

var fpath = 'res://data/user_settings.ini'

var token 
var token_c

func _ready():
	check_base_file()


func check_base_file():
	var config = ConfigFile.new()
	var err

	err = config.load(fpath)
	
	if err != OK:
		print('"User_Config.cfg" not found \n' + 'Creating "User_Config.cfg" file')
		config.set_value("User", "Nickname", "Type your username here")
		config.set_value("User", "BotToken", '*'.repeat(25))
		config.save(fpath)
		userline.text = "Type your username here"
		botline.text = '*'.repeat(25)
		print('Passou 01')


	for User in config.get_sections():
		var n = config.get_value(User, "Nickname")
		var sz = config.get_value(User, "BotToken")
		token = sz
		
		userline.text = str(config.get_value(User, "Nickname"))
		botline.text = '*'.repeat(sz.length())
		token_c = botline.text


func updating_file():
	var config = ConfigFile.new()
	var sz
	
	if token_c != botline.text:
		config.set_value("User", "BotToken", botline.text)
	else:
		config.set_value("User", "BotToken", token)
	config.set_value("User", "Nickname", userline.text )
	config.save(fpath)
	print(botline.text)
	sz = botline.text
	botline.text = '*'.repeat(sz.length())
	token_c = botline.text


func _on_Save_User_Bot_button_up():
	updating_file()
