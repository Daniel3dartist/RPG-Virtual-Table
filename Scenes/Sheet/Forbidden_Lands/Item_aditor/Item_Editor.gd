extends Control

var BASE_PATH = "res://Scenes/Sheet/Forbidden_Lands/Itens/"
var file = 'items_list.ini'

#onready var item_menu = preload("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Items_list_menu.tscn")
onready var TabCont = $'Panel/VBoxContainer/TabContainer'
var tab_id = 0

var weapons: Array
var armor: Array
var shields: Array
var list: Dictionary = {
	'weapons': '',
	'shields':'',
	'armor': ''
}

func _ready():
	init()


func init():
	var path = BASE_PATH + file
	var cfg = ConfigFile.new()
	var err = cfg.load(path)
	
	if err != OK:
		print('File not exist...')
		pass
	else:
		weapons = cfg.get_value("Items List", 'weapons')
		armor = cfg.get_value("Items List", 'armor')
		shields = cfg.get_value("Items List", 'shields')
	
	var array = [weapons, armor, shields]
	for i in array.size():
		if array[i] == null:
			array[i].clear()
	
	var item_id = cfg.get_value('Edit', 'item')
	if item_id != null:
		var item
		var _name = self.get_node('Panel/VBoxContainer/TabContainer/%s/HBoxContainer/LineEdit' % item_id[1])
		var _cost = self.get_node('Panel/VBoxContainer/TabContainer/%s/HBoxContainer2/Cost/SpinBox' % item_id[1])
		var _desc = self.get_node('Panel/VBoxContainer/TabContainer/%s/TextEdit' % item_id[1])
		match item_id[1]:
			'Weapons':
				item = weapons[item_id[0]]
				TabCont.current_tab = 0
			'Shields':
				item = shields[item_id[0]]
				TabCont.current_tab = 1
			'Armor':
				item = armor[item_id[0]]
				TabCont.current_tab = 2
		_name.text = str(item['name'])
		_cost.value = item['cost']
		_desc.text = item['property'][0]

func _on_Save_button_up():
	grab_item()
	save_item()
	_back_to_item_menu()
	


func save_item():
	var path = BASE_PATH + file
	var cfg = ConfigFile.new()
	var err = cfg.load(path)
	
	if err != OK:
		print('File not exist...')
		pass
	
	cfg.set_value("Items List", 'weapons', weapons)
	cfg.set_value("Items List", 'armor', armor)
	cfg.set_value("Items List", 'shields', shields)
	cfg.set_value('Edit', 'item', null)
	cfg.save(path)


func grab_item():
	var dic: Dictionary
	var _name
	var txt
	var parent
	var property_type: Array
	var checkers = TabCont.get_parent().get_node("HBoxContainer/property_type")
	
	for i in checkers.get_child_count():
		if checkers.get_child(i).pressed == true:
			property_type.push_back(checkers.get_child(i).text)

	match TabCont.current_tab:
		0:
			parent = TabCont.get_node("Weapons")
			_name = parent.get_node("HBoxContainer/LineEdit").text
			txt = parent.get_node("TextEdit").text
			dic = {
				'name': _name,
				'class': "Weapons",
				'handle': parent.get_node("HBoxContainer2/Handle/SpinBox").value,
				'bonus':  parent.get_node("HBoxContainer2/Bonus/SpinBox").value,
				'damage': parent.get_node("HBoxContainer2/Damage/SpinBox").value,
				'range': parent.get_node("HBoxContainer2/Range/MenuButton").text.replace(' [V]', ''),
				'cost': parent.get_node("HBoxContainer2/Cost/SpinBox").value,
				'property': [txt, property_type]
			}
			if weapons == null:
				weapons = [dic]
			else:
				check_item(_name, dic['class'])
				weapons.push_back(dic)
		1:
			parent = TabCont.get_node("Shields")
			_name = parent.get_node("HBoxContainer/LineEdit").text
			txt = parent.get_node("TextEdit").text
			dic = {
				'name': str(parent.get_node("HBoxContainer/LineEdit").text),
				'class': "Shields",
				'handle': parent.get_node("HBoxContainer2/Handle/SpinBox").value,
				'bonus':  parent.get_node("HBoxContainer2/Bonus/SpinBox").value,
				'damage': parent.get_node("HBoxContainer2/Damage/SpinBox").value,
				'range': parent.get_node("HBoxContainer2/Range/MenuButton").text.replace(' [V]', ''),
				'cost': parent.get_node("HBoxContainer2/Cost/SpinBox").value,
				'property': [str(parent.get_node("TextEdit").text), property_type]
			}
			if shields == null:
				shields = [dic]
			else:
				check_item(_name, dic['class'])
				shields.push_back(dic)
		2:
			parent = TabCont.get_node("Armor")
			_name = parent.get_node("HBoxContainer/LineEdit").text
			txt = parent.get_node("TextEdit").text
			if txt == null or txt == '' or txt == ' ':
				txt = '__'
			dic = {
				'name': _name,
				'class': "Armor",
				'bonus':  parent.get_node("HBoxContainer2/ValordeArmadura/SpinBox").value,
				'body_part': parent.get_node("HBoxContainer2/Body_Part/MenuButton").text.replace(' [V]', ''),
				'cost': parent.get_node("HBoxContainer2/Cost/SpinBox").value,
				'property': [txt, property_type]
			}
			if armor == null:
				armor = [dic]
			else:
				check_item(_name, dic['class'])
				armor.push_back(dic)


func check_item(_name, _class):
	var item
	match _class:
		'Weapons':
			item = weapons
		'Shields':
			item = shields
		'Armor':
			item = armor
	remove_item(item, _name, _class)

func remove_item(item, _name, _class):
	var array = item
	var list = array
	var num = 0
	for i in array:
		var _name_ = array[num]["name"]
		if _name_ == _name:
			list.remove(num)
		else:
			pass
		num+=1
	array = list
	match _class:
		'Weapons':
			weapons = array
		'Shields':
			shields = array
		'armor':
			armor = array


func _on_Exit_button_up():
	_back_to_item_menu()
#	self.queue_free()


func _on_Cancel_button_up():
	_back_to_item_menu()


func _back_to_item_menu():
	get_tree().change_scene("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Items_list_menu.tscn")
