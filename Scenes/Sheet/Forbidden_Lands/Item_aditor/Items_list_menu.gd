extends Panel

signal add_item(item, box)

var is_block: bool = false
var dragging: bool = false
var off_set

var file = "items_list.ini"
var BASE_PATH = "res://Scenes/Sheet/Forbidden_Lands/Itens/"
onready var class_title = $'VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/HBoxContainer/Class'
onready var class_image = $'VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/HBoxContainer/ColorRect/TextureRect'

onready var tab = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/VBoxContainer/ScrollContainer/TabContainer
onready var weapons_grid = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/VBoxContainer/ScrollContainer/TabContainer/Weapons_grid
onready var shields_grid = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/VBoxContainer/ScrollContainer/TabContainer/Shield_grid
onready var armor_grid = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/VBoxContainer/ScrollContainer/TabContainer/Armor_grid
onready var class_select = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer
onready var item_image = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer2/ColorRect/TextureRect

onready var item = preload("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Item_Selection_Buttom.tscn")
onready var item_edit = preload("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Item_Editor.tscn")


var dic: Dictionary


func _ready():
	var dirpath = '%s/data/RPGsys/Forbidden_Lands/item/' % OS.get_executable_path().get_base_dir()
	print('Has Data')
	if Directory.new().open(dirpath) == OK:
		BASE_PATH = dirpath
	var _class
	var cfg = ConfigFile.new()
	cfg.load(BASE_PATH + file)
	dic = {
		'weapons': cfg.get_value("Items List", 'weapons'),
		'shields': cfg.get_value("Items List", 'shields'),
		'armor': cfg.get_value("Items List", 'armor'),
	}
	class_select.get_node("CheckBox_Weapons").pressed = true
	class_image.texture = load("res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/Longbow.png")
	
	var item_array = ['weapons','shields', 'armor']
	for i in item_array.size():
		_class = item_array[i]
		for x in dic[_class].size():
			if dic[_class][x] == null:
				pass
			else:
				var item_ui = item.instance()
				if _class =='weapons':
					weapons_grid.add_child(item_ui)
				elif _class =='shields':
					shields_grid.add_child(item_ui)
				elif _class == 'armor':
					armor_grid.add_child(item_ui)
				item_ui.text = dic[_class][x]['name']
				var path = "res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/%s.png"  % item_ui.text.replace(' ', '_')
				item_ui.icon = load(path)
				item_ui.connect("_item_button_up", self, "_item_button_up")
				item_ui.connect("_edit_item", self, "_edit_item")


func _input(event):
	# Drag-and-drop sheet
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		off_set = rect_position - get_global_mouse_position()

#		var area = color_rect.rect_size
		var mouse = get_global_mouse_position()
		
		if is_block == false:
			print('Is mouse position\n')
#			set_default_cursor_shape(13)
			dragging = true
	if Input.is_action_just_released("left_mouse"):
		dragging = false
	if Input.is_action_just_released("Del"):
		var cfg = ConfigFile.new()
		var del_list: Array
		var _class
		var array: Array
		cfg.load(BASE_PATH + file)
		
		match tab.current_tab:
			0:
				_class = 'Weapons_grid'
				array = dic['weapons']
					
			1:
				_class = 'Shield_grid'
				array = dic['shields']
			2:
				_class = 'Armor_grid'
				array = dic['armor']

		for i in tab.get_node(_class).get_child_count():
			var item = tab.get_node(_class).get_child(i)
			if item.modulate == Color('#98e0ff'):
				del_list.push_back(i)
		for i in del_list.size():
			tab.get_node(_class).get_child(del_list[i]).queue_free()
			array.remove(del_list[i])
		_class = _class.split('_')
		_class = _class[0].to_lower()
		cfg.set_value("Items List", _class, array)
		cfg.save(BASE_PATH + file)


func _process(delta):
#	var area = color_rect.rect_size
	var mouse = get_global_mouse_position()
	
	if dragging == true and get_viewport().get_mouse_position().y > 0.0:
		var view = get_viewport().get_mouse_position()
		rect_position = view + off_set


func _edit_item(id):
	var _class = $VBoxContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/HBoxContainer/Class.text
	if $VBoxContainer/HBoxContainer/Label.text == 'Edit Mode':
		var cfg = ConfigFile.new()
		cfg.load(BASE_PATH + file)
		cfg.set_value('Edit', 'item', [id, _class])
		cfg.save(BASE_PATH + file)
		get_tree().change_scene("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Item_Editor.tscn")


func _item_button_up(id, tab, _name):
	print(_name)
	_name = _name.replace(' ', '_')
	var path = "res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/%s.png"  % _name
	var img = Image.new()
	img = load(path)
	var texr = ImageTexture.new()
	texr = img
	item_image.texture = img
	item_image.stretch_mode = 6


func _on_CheckBox_Weapons_pressed():
	tab.current_tab = 0
	class_title.text = "Weapons"
	class_image.texture = load("res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/Longbow.png")
	print(0)

func _on_CheckBox_Shields_pressed():
	tab.current_tab = 1
	class_title.text = "Shields"
	class_image.texture = load("res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/Large_Shield.png")
	print(1)


func _on_CheckBox_Armor_pressed():
	tab.current_tab = 2
	class_title.text = "Armor"
	class_image.texture = load("res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/Leather_Armor.png")
	print(2)


func _on_Button_button_up():
	self.queue_free()


func _on_Container_mouse_entered():
	is_block == false


func _on_Container_mouse_exited():
	is_block == true


func _on_Add_button_up():
	var array: Array
	var box = $VBoxContainer/HBoxContainer/Label.text
	match tab.current_tab:
		0:
			for i in weapons_grid.get_child_count():
				if weapons_grid.get_child(i).pressed == true:
					array.push_back(dic['weapons'][i])
		1:
			for i in shields_grid.get_child_count():
				if shields_grid.get_child(i).pressed == true:
					array.push_back(dic['shields'][i])
		2:
			for i in armor_grid.get_child_count():
				if armor_grid.get_child(i).pressed == true:
					array.push_back(dic['armor'][i])
	emit_signal("add_item", array, box)
