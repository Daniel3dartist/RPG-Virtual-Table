extends Control

# Number of table created
var table_num = 00

# Default scenes to add
var add_table = preload("res://Scenes/Table.tscn")
var table_description = preload("res://Scenes/Table Description.tscn")
var table_name = preload("res://Scenes/Table Name.tscn")

# Place to list the tables
onready var table_list = $'ColorRect/VBoxContainer/VBoxContainer/Table List'

func _on_Add_a_New_Table_button_up():
	var txt = 'Table'
	
	var Tname = table_name.instance()
	var table = add_table.instance()
	var card = table_description.instance()
	
	if table_num > 0:
		txt = txt + ('(%s)' % str(table_num))
	
	Tname.text = txt
	card.add_child(Tname)
	table_list.add_child(card)
	table_num = table_num + 1
