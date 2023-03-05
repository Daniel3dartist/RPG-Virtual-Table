extends HBoxContainer

onready var equipped_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/VBoxContainer/HBoxContainer/Button
onready var backpack_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/HBoxContainer/Button
onready var dropped_b = $Inventory2/ScrollContainer/HBoxContainer/VBoxContainer3/VBoxContainer3/HBoxContainer2/Button

onready var item_list = preload("res://Scenes/Sheet/Forbidden_Lands/Item_aditor/Items_list_menu.tscn")

func _ready():
	equipped_b.connect("button_up", self, 'add_equipped')
	backpack_b.connect("button_up", self, 'add_backpack')
	dropped_b.connect("button_up", self, 'add_dropped')
	
func spaw_item_list():
	var table = get_tree().get_root().get_node('Table')
	var items_menu = item_list.instance()
	table.get_node('Sheet_Spaw').add_child(items_menu)


func add_equipped():
	spaw_item_list()
	
	
func add_backpack():
	spaw_item_list()
	
	
func add_dropped():
	spaw_item_list()
