extends HBoxContainer

onready var equipped_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Equipped_Box/HBoxContainer/Button
onready var backpack_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Backpack_Box/HBoxContainer/Button
onready var dropped_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Dropped_Box/HBoxContainer2/Button

onready var item_list = preload("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Items_list_menu.tscn")
onready var item_panel = preload('res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Item_panel.tscn')

func _ready():
	equipped_b.connect("button_up", self, 'add_equipped')
	backpack_b.connect("button_up", self, 'add_backpack')
	dropped_b.connect("button_up", self, 'add_dropped')
	
func spaw_item_list(_name):
	var table = get_tree().get_root().get_node('Table')
	var item_menu = item_list.instance()
	table.get_node('Sheet_Spaw').add_child(item_menu)
	item_menu.connect("add_item", self, '_add_item')
	item_menu.get_node('VBoxContainer/HBoxContainer/Label').text = _name

# $
func _add_item(item, box):# $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/Equipped_Box/ScrollContainer/VBoxContainer/Weapons_Box/Panel/VBoxContainer/ScrollContainer/VBoxContainer
	var _box = self.get_node('Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/%s_Box/ScrollContainer/VBoxContainer/%s_Box/Panel/VBoxContainer/ScrollContainer/VBoxContainer' % [box, item[0]['class']])
	for i in item.size():
		var _item = item_panel.instance()
		var _name = item[i]['name']
		_box.add_child(_item)
		_item.get_node("HBoxContainer/Panel/TextureRect").texture = load("res://Scenes/Sheet/Forbidden_Lands/Itens/Item_illustrations/%s.png" % _name.replace(' ', '_')) 
		_item.get_node("HBoxContainer/Button").text = _name
		_item.get_node("HBoxContainer/HBoxContainer/Cost").text = str(item[i]['cost'])
		if item[i]['class'] != 'Armor':
			_item.get_node("HBoxContainer/HBoxContainer/Class").text = item[i]['class']
			_item.get_node("HBoxContainer/HBoxContainer/Damage").text = str(item[i]['damage'])
			_item.get_node("HBoxContainer/HBoxContainer/Handle").text = str(item[i]['handle'])
			_item.get_node("HBoxContainer/HBoxContainer/Range").text = item[i]['range']
		else:
# CA			_item.get_node()
# Body Part		_item.get_node()
			pass



func add_equipped():
	spaw_item_list('Equipped')
	
	
func add_backpack():
	spaw_item_list('Backpack')
	
	
func add_dropped():
	spaw_item_list('Dropped')
