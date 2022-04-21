extends Control

var main_menu = 'res://Scenes/Main Menu.tscn'

# Number of table created
var table_num = 00

# Default scenes to add
var add_table = preload("res://Scenes/Table.tscn")
var table_description = preload("res://Scenes/Table Description.tscn")
var table_name = preload("res://Scenes/Table Name.tscn")
var table_color = preload("res://Scenes/Table_color.tscn")
var table_desc_itens = preload("res://Scenes/Table_desc_itens.tscn")
var tcard = preload('res://Scenes/Card.tscn')

# Place to list the tables
onready var table_list = $'ColorRect/VBoxContainer/VBoxContainer/ScrollContainer/Table List'


func _ready():
	Creat_Table_List()


func _on_Main_Menu_button_up():
	get_tree().change_scene(main_menu)

func _on_Add_a_New_Table_button_up():
	var txt = 'Table'
	
	var r = randf() + randf()
	var g = randf() + randf()
	var b = randf() + randf()
	
	var tcolor = table_color.instance()
	var Tname = table_name.instance()
	var table = add_table.instance()
	var card = tcard.instance()
	var card_itens = table_description.instance()
	var tdbox = table_desc_itens.instance()
	
	tdbox.add_child(Tname)
	#tdbox.add_child(Tname)
	tcolor.color = Color(r, g, b)
	
	if table_num > 0:
		txt = txt + ('(%s)' % str(table_num))
	
	Tname.text = txt
	card_itens.add_child(tcolor)
	card_itens.add_child(tdbox)
	card.add_child(card_itens)
	
	table_list.add_child(card)
	table_num = table_num + 1


func Creat_Table_List():
	pass
