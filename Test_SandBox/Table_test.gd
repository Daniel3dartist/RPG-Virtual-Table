extends Control

var fpath = 'res://Test_SandBox/Save.save'

var sheet_num
var sheet_list = []
var sheet = {
		'Name': '',
		'Number': '',
		'Path': '',
	}

onready var sheet_container = $"Base_UI/Chat_&_Rolls_Results/HBoxContainer/SplitSheetList/SheetList"
var sheet_call_Hbox = preload('res://Scenes/SheetCallHBox.tscn')
var sheet_call = preload("res://Scenes/SheetCall.tscn")


func _ready():
	check_exist_file()


func check_exist_file():
	var config = ConfigFile.new()
	var err = config.load(fpath)
	
	if err != OK:
		print('File not found...')
		config.set_value("Sheets", "Sheets", sheet_list)
		config.save(fpath)
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
	var SPath = txt
	
	sheet_num = sheet_list.size()
	
	if sheet_num > 0:
		txt = 'Sheet (%s)' % sheet_num
		SPath = txt

	sheet = {
		'Name': txt,
		'Number': sheet_num,
		'Path': 'res://data/Sheets/%s.save' % SPath,
	}
	sheet_list.push_back(sheet)

	sheet_call_instance.text = txt
	sheet_box_instance.add_child(sheet_call_instance)
	sheet_container.add_child(sheet_box_instance)
	sheet_num = sheet_num + 1
	
	var save = ConfigFile.new()
	save.set_value("Sheet", "Name", txt)
	save.save(sheet["Path"])
	update_list()

func update_list():
	var config = ConfigFile.new()
	var err = config.load(fpath)
	
	if err == OK:
		config.set_value("Sheets", "Sheets", sheet_list)
		config.save(fpath)
