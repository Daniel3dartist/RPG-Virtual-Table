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

# Place to list the tables
onready var table_list = $'ColorRect/VBoxContainer/VBoxContainer/Table List'

func _on_Main_Menu_button_up():
	get_tree().change_scene(main_menu)

func _on_Add_a_New_Table_button_up():
	var txt = 'Table'
	
	var tcolor = table_color.instance()
	var Tname = table_name.instance()
	var table = add_table.instance()
	var card = table_description.instance()
	var tdbox = table_desc_itens.instance()
	
	tdbox.add_child(Tname)
	#tdbox.add_child(Tname)
	
	if table_num > 0:
		txt = txt + ('(%s)' % str(table_num))
	
	Tname.text = txt
	card.add_child(tcolor)
	card.add_child(tdbox)
	table_list.add_child(card)
	table_num = table_num + 1



