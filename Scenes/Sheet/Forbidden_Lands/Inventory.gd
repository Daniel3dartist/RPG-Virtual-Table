extends HBoxContainer

onready var equipped_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Equipped_Box/HBoxContainer/Button
onready var backpack_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Backpack_Box/HBoxContainer/Button
onready var dropped_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Dropped_Box/HBoxContainer/Button

onready var item_list = preload("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Items_list_menu.tscn")
var item_panel 

func _ready():
	equipped_b.connect("button_up", self, 'add_equipped')
	backpack_b.connect("button_up", self, 'add_backpack')
	dropped_b.connect("button_up", self, 'add_dropped')


func _input(event):
	var box = ['Equipped', 'Backpack', 'Dropped']
	var _class = ['Weapons', 'Shields', 'Armor', 'Misc']
	if Input.is_action_just_released('Del'):
		for i in box.size():
			for x in _class.size():
				var _box = self.get_node('Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/%s_Box/ScrollContainer/VBoxContainer/%s_Box/Panel/VBoxContainer/ScrollContainer/VBoxContainer' % [box[i], _class[x]])
				for y in _box.get_child_count():
					if _box.get_child(y).modulate != Color('#ffffff'):
						_box.get_child(y).queue_free()


func spaw_item_list(_name):
	var table = get_tree().get_root().get_node('Table')
	var item_menu = item_list.instance()
	table.get_node('Sheet_Spaw').add_child(item_menu)
	item_menu.connect("add_item", self, '_add_item')
	item_menu.get_node('VBoxContainer/HBoxContainer/Label').text = _name


func _add_item(item, box):# $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Equipped_Box/ScrollContainer/VBoxContainer/Weapons_Box/Panel/VBoxContainer/ScrollContainer/VBoxContainer
	var _box = self.get_node('Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/%s_Box/ScrollContainer/VBoxContainer/%s_Box/Panel/VBoxContainer/ScrollContainer/VBoxContainer' % [box, item[0]['class']])
#	var hide_show = self.get_node('Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/%s_Box/ScrollContainer/VBoxContainer/%s_Box/Panel/Panel/HBoxContainer2/HBoxContainer/Hide_show' % [box, item[0]['class']])
	for i in item.size():
		if item[i]['class'] == 'Armor':
			item_panel = load("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Item_panel_armor.tscn")
		else:
			item_panel = load('res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Item_panel.tscn')
		var _item = item_panel.instance()
		var _name = item[i]['name']
		_box.add_child(_item)
		_item.get_node("HBoxContainer/Panel/TextureRect").texture = load("res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/%s.png" % _name.replace(' ', '_')) 
		_item.get_node("HBoxContainer/Button").text = _name
		_item.get_node("HBoxContainer/HBoxContainer/Cost").text = str(item[i]['cost'])
		_item.get_node("HBoxContainer/HBoxContainer/Class").text = item[i]['class']
		if item[i]['class'] != 'Armor':
			_item.get_node("HBoxContainer/HBoxContainer/Damage").text = str(item[i]['damage'])
			_item.get_node("HBoxContainer/HBoxContainer/Handle").text = str(item[i]['handle'])
			_item.get_node("HBoxContainer/HBoxContainer/Range").text = item[i]['range']
		else:
# CA			
			_item.get_node('HBoxContainer/HBoxContainer/Bonus').text = str(item[i]['bonus'])
# Body Part
			_item.get_node('HBoxContainer/HBoxContainer/Body_Part').text = item[i]['body_part']
			pass



func add_equipped():
	spaw_item_list('Equipped')
	
	
func add_backpack():
	spaw_item_list('Backpack')
	
	
func add_dropped():
	spaw_item_list('Dropped')
