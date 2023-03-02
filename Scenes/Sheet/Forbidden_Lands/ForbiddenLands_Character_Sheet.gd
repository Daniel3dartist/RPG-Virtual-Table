extends Control

signal update_sheet_list(array)

onready var BASE_PATH = OS.get_executable_path().get_base_dir()
onready var sheet_list_path = self.get_parent().get_parent().get_node('Base_UI/Chat_&_Rolls_Results/TabContainer/SheetList/ScrollContainer/VBoxContainer')

var off_set
var dragging: bool = false
var is_block: bool = true
onready var pos2d = $'CanvasLayer/Node2D'
onready var color_rect = $'Panel/Container' #$"CanvasLayer/ColorRect2"

onready var char_name = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/CharacterBaseArea/CharacterName_BoxC/Character_Name'
var _index: int = 0
var old_name: String
var sheet

onready var race_menu = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/CharacterBaseArea/CharacterRace_BoxC/Panel/MenuButton'
var is_age
var age_category: Dictionary = {
	"max_min":  {
		"Young": [16,25],
		"Adult": [26,50],
		"Old": [51]
	},
	'Human': {
		"Young": [16,25],
		"Adult": [26,50],
		"Old": [51]
	},
	'Half-Elf': {
		"Young": [16,30],
		"Adult": [31,100],
		"Old": [101]
	},
	'Dwarf': {
		"Young": [20,40],
		"Adult": [41,80],
		"Old": [81]
	},
	'Halfling': {
		"Young": [16,25],
		"Adult": [26,60],
		"Old": [61]
	},
	'Wolfkin': {
		"Young": [13,20],
		"Adult": [21,40],
		"Old": [41]
	},
	'Orc': {
		"Young": [13,20],
		"Adult": [21,45],
		"Old": [46]
	},
	'Goblin': {
		"Young": [16,25],
		"Adult": [26,60],
		"Old": [61]
	},
}

onready var class_menu = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/CharacterBaseArea/CharacterClass_BoxC/Panel2/MenuButton'

func _ready():
	old_name = char_name.text
	$'Panel'.rect_position = Vector2(235-15, 60)
	var table = self.get_parent().get_parent()
	print('\n\n Parente Parente: %s\n\n' % table)
	table.connect('receive_sheet_data', self, '_Receive_Sheet_Data')
	table.connect('index', self, '_Index')
	emit_signal("give_data")
	race_menu.get_popup().connect("id_pressed", self, "Popup_race_id_pressed")
	class_menu.get_popup().connect("id_pressed", self, "Popup_class_id_pressed")

func _input(event):
	var age_label = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Age/HBoxContainer/Label2'
	var reputation_age_mod = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Reputation/HBoxContainer/Label2'
	var reputation = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Reputation/HBoxContainer/Panel/SpinBox'
	var rep_total = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Reputation/HBoxContainer/Reputation_Total'
	if Input.is_action_just_released("enter") or Input.is_action_just_released("left_mouse"):
		_set_age_mod()


# Drag-and-drop sheet
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		off_set = rect_position - get_global_mouse_position()

#		var area = color_rect.rect_size
		var mouse = get_global_mouse_position()
		
		if is_block == false:
			print('Is mouse position\n')
			set_default_cursor_shape(13)
			dragging = true
	if Input.is_action_just_released("left_mouse"):
		dragging = false

func _process(delta):
#	var area = color_rect.rect_size
	var mouse = get_global_mouse_position()
	
	if dragging == true and get_viewport().get_mouse_position().y > 0.0:
		var view = get_viewport().get_mouse_position()
		rect_position = view + off_set
		pos2d.position = pos2d.position - rect_position 
#		color_rect.rect_position = view + off_set


func _Receive_Sheet_Data(dic):
	sheet = dic
	char_name.text = dic['name']
	print('\n\nData recebido %s\n\n' % sheet)


# save edits
func _Update_Save():
	var packed_scene = PackedScene.new()
	var _name = old_name
	var dir = Directory.new()
	var buttom = sheet_list_path.get_child(sheet['id']).get_child(1)
	var path_label = sheet_list_path.get_child(sheet['id']).get_child(2)
	var old_path = path_label.text
	var txt = path_label.text
	print('\n\nPath_Label: \n', txt.replace('%s.tscn'%buttom.text, '%s.tscn'% 'maria'))
	old_name = buttom.text
	var sub = txt.find_last('Sheets')
	var knum = 'Sheets'.length()

	if old_name != char_name.text:
		_name = char_name.text +'.tscn' 
		if buttom.text == old_name:
			buttom.text = char_name.text
			old_path = path_label.text
			old_name = buttom.text + '.tscn'
			print(txt)
			txt = txt.substr(0, sub + knum)
			txt = txt + '/%s' % _name
#			var list = '/'.join(txt)
#			print('list: ',list)
#			path_label.text = txt 
			print('\n\nOld: \n', old_path, '\n\nNew: \n', _name,'\n\n', txt)
	dir = txt
	buttom.text = char_name.text
	path_label.text = dir
	print('\nTXT:', dir)
	Directory.new().rename(str(old_path), str(path_label.text))
	color_rect.rect_position = Vector2(280, 60)
	$'Panel'.rect_position = Vector2(235-15, 60)
	packed_scene.pack(self)
	ResourceSaver.save(dir, packed_scene)
	var cfg = ConfigFile.new()
	var table_path = '%s/data/last_played.ini' % BASE_PATH
	print('\n\n\n%s\n\n\n' % table_path)
	cfg.load(table_path)
	table_path = cfg.get_value('Last Played', 'path')
	cfg.load(table_path)
	var sheet_list = cfg.get_value('Table', 'sheets')
	sheet_list[sheet['id']]['name'] = char_name.text
	sheet_list[sheet['id']]['path'] = dir
	cfg.set_value('Table', 'sheets', sheet_list)
	emit_signal('update_sheet_list', sheet_list)
	cfg.save(table_path)
	print(sheet_list)
#	emit_signal("Save_sheet_path", [old_path, dir] )
#	pass

func _set_age_mod():
	var age_label = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Age/HBoxContainer/Label2'
	var reputation_age_mod = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Reputation/HBoxContainer/Label2'
	var reputation = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Reputation/HBoxContainer/Panel/SpinBox'
	var rep_total = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Reputation/HBoxContainer/Reputation_Total'
	var value = $'Panel/SheetArea/Sheet_TabContainer/ScrollContainer/HBoxContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/Age/HBoxContainer/Panel/SpinBox'.value
	print(value)
	if int(value) >= age_category['max_min']['Young'][0] and int(value) <= age_category['max_min']['Young'][1]:
		age_label.text = 'Young'
		reputation_age_mod.text = '%s+' % 0
		rep_total.text = str(0 + reputation.value)
	elif int(value) >= age_category['max_min']['Adult'][0] and int(value) <= age_category['max_min']['Adult'][1]:
		age_label.text = 'Adult'
		reputation_age_mod.text = '%s+' % 1
		rep_total.text = str(1 + reputation.value)
	elif int(value)>= age_category['max_min']['Old'][0]:
		age_label.text = 'Old'
		reputation_age_mod.text = '%s+' % 2
		rep_total.text = str(2 + reputation.value)


func Popup_race_id_pressed(id):
	match id:
		0:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['Human']
		1:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['Half-Elf']
		2:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['Dwarf']
		3:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['Halfling']
		4:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['WolfKin']
		5:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['Orc']
		6:
			race_menu.text = race_menu.get_popup().get_item_text(id)
			age_category['max_min'] = age_category['Goblin']
	_set_age_mod()


func Popup_class_id_pressed(id):
	match id:
		0:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		1:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		2:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		3:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		4:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		5:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		6:
			class_menu.text = class_menu.get_popup().get_item_text(id)
		7:
			class_menu.text = class_menu.get_popup().get_item_text(id)


func _on_Sheet_Exit_button_up():
	self.queue_free()


func _on_Container_mouse_entered():
	is_block = false


func _on_Container_mouse_exited():
	is_block = true


func _on_Save_Button_button_up():
	_Update_Save()


func _on_SpinBox_mouse_entered():
	is_age = true


func _on_SpinBox_mouse_exited():
	is_age = false



