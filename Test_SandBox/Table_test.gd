extends Control

var fpath 

var snum
var sheet_num = 0
var sheet_list = []
var sheet = {
		'Name': '',
		'Number': '',
		'Path': '',
	}
var character_sheet_path = preload("res://Scenes/Sheet/Character_Sheet.tscn")

onready var sheet_container = $"Base_UI/Chat_&_Rolls_Results/TabContainer/SheetList"
var sheet_call_Hbox = preload('res://Scenes/Table/SheetCallHBox.tscn')
var sheet_call = preload("res://Scenes/Table/SheetCall.tscn")

# signals
signal receive_sheet_data(data_path)

# Functions
func _ready():
	var config = ConfigFile.new()
#	var err = config.load('res://data/last_played.ini')
	var last = ConfigFile.new()
	var sz = 0
	var num
	
	last.load('res://data/last_played.ini')
	print(last.get_sections())
	fpath = last.get_value("Last Played", "Last table")['path']
	print('Self Index ready table: \n', fpath)
	
	check_exist_file()
	config.load(fpath)
	for Sheets in config.get_sections():
		sheet_list = config.get_value(Sheets, 'Sheets')
	num = sheet_list.size()
	while num  > sz:
		organize_sheet_list(sz)
		sz += 1 


func check_exist_file():
	var config = ConfigFile.new()
	var err 
	var dir = Directory.new()
	
	err = dir.open(fpath + '/Sheets')
	if err != OK:
		dir.open(fpath)
		dir.make_dir('Sheets')
	
	err = config.load(fpath + '/Sheet_List.save')
	if err != OK:
		print('File not found...')
		config.set_value("Sheets", "Sheets", sheet_list)
		config.save(fpath + '/Sheet_List.save')
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
	var SPath = '%s/Sheet/Sheet' % fpath
	var dir = Directory.new()
	var Dname = txt
	var Dpath =  '%s/Sheets' % fpath

	sheet_num = sheet_list.size()
	print(Dpath)
	if sheet_num > 0:
		txt = 'Sheet (%s)' % sheet_num
		Dname = Dname + '(%s)' % sheet_num
		SPath =fpath + '/'+ Dname + '/'+ Dname
		Dpath = Dpath + '/'+ Dname
		print(Dpath)

	sheet = {
		'Name': txt,
		'Number': sheet_num,
		'Path': '%s.save' % SPath,
	}
	
	
#	dir.open(Dpath)
#	dir.make_dir(Dname)
	
	dir.open('%s/Sheets/' % fpath)
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
	print('fpath: ', fpath)
	update_list()

func update_list():
	var config = ConfigFile.new()
	var err = config.load(fpath + '/Sheet_List.save')
	
	if err == OK:
		config.set_value("Sheets", "Sheets", sheet_list)
		config.save(fpath + '/Sheet_List.save')


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
	var SPath = '%s/Sheet/Sheet' % fpath
	var Dname = txt

	if sz > 0:
		txt = 'Sheet (%s)' % sheet_num
		Dname = Dname + '(%s)' % sheet_num
		SPath = fpath + '/'+ Dname + '/'+ Dname
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
	name = name.replace(' ', '')
	print('Sheet_List: ', sheet_list[index - 1])
	print('Name dir: ', name)
	dir.open(fpath + '/Sheets')
	dir.remove(fpath + '/Sheets/%s' % name)
	print('delete sheet ')
	
	sheet_list.remove(index - 1)
	update_list()
