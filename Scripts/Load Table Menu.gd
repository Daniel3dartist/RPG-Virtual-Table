extends Control

var t = true

var fpath = 'res://data/table_list.json'
var main_menu = 'res://Scenes/Main Menu.tscn'

# Number of table created
var table_num = 0
var num_of_tables 
var last_table = 0
var n = 0

# Table dictionary of itens
var tboxdic = {
	'number': '',
	'name': '',
	'pic': '',
	'desc': ''}

# List of table container saved
var tboxlist = []

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
	var f = File.new()
	var txtparse
	var size
	var sz = 0
	
	check_if_Table_List_File_Exist()
	f.open(fpath, File.READ)
	txtparse = f.get_as_text()
	txtparse = parse_json(txtparse)
	print('TXT parse: (%s)' % str(txtparse))
	f.close()
	
	size = txtparse.size()
	while size > sz:
		print(size)
		print(sz)
		print('N: ', n)
		organize_the_table_list(sz)
		sz += 1

#func _process(delta):
#	if num_of_tables > 0:
#		organize_the_table_list()


func _on_Main_Menu_button_up():
	get_tree().change_scene(main_menu)

func _on_Add_a_New_Table_button_up():
	add_table()


func Creat_Table_List():
	var f = File.new()
	
	f = f.file_exists(fpath)
	f = File.new()
	f.open(fpath, File.WRITE)
	f.store_string(to_json([]))
	table_num = 0
	print('Table List File Created... \n')


func check_if_Table_List_File_Exist():
	var f = File.new()
	
	f = f.file_exists(fpath)
	if f != true:
		Creat_Table_List()
	else:
		print('Table List File exist... \n')
#		organize_the_table_list()

func update_list_json():
	var f = File.new()
	var box
	
	tboxdic['number'] = table_num
	tboxdic['name'] = "Origame"
	tboxdic['pic'] = Color(2, 25, 50)
	tboxdic['desc'] = "Isso é uma desc"
#	tboxdic = {
#		'number': table_num,
#		'name': Tname.text
#	}
	f.open(fpath, File.WRITE)
#	box = tboxlist.append(tboxdic)
	box = tboxdic
#	box = txtparse
#	box = parse_json(box)
#	box = box.append(tboxdic)
#	print("Box: (%s)" % str(box))
	f.store_string(to_json(tboxlist))
	print('Table List File updated... \n')


func organize_the_table_list(value):
	var f = File.new()
	
	var txt = 'Table'
	var txtparse
	var keysn
	
	var tcolor = table_color.instance()
	var Tname = table_name.instance()
	var table = add_table.instance()
	var card = tcard.instance()
	var card_itens = table_description.instance()
	var tdbox = table_desc_itens.instance()

	f.open(fpath, File.READ)
	txtparse = f.get_as_text()
	txtparse = parse_json(txtparse)
#	print('TXT parse: (%s)' % str(txtparse))
	f.close()
	
#	print('Esse é a lista do NUM: ', txtparse[n])
	
	keysn = txtparse.size() #+ 1
	print('Keysn: ' , keysn)

	tdbox.add_child(Tname)
	#tdbox.add_child(Tname)
	tcolor.color = Color(txtparse[value]['pic'][0],txtparse[value]['pic'][1],txtparse[value]['pic'][2])
	Tname.text = txtparse[value]['name']
	card_itens.add_child(tcolor)
	card_itens.add_child(tdbox)
	card.add_child(card_itens)
	table_list.add_child(card)
	print('This is Num: ' , value)
	print('This is Num: ', n)
	table_num = value + 1




func add_table():
	var f = File.new()
	
	var txt = 'Table'
	var txtparse
	
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
	
	f.open(fpath, File.READ)
	txtparse = f.get_as_text()
	txtparse = parse_json(txtparse)
#	print('TXT parse: (%s)' % str(txtparse))
	f.close()
	
	Tname.text = txt
	card_itens.add_child(tcolor)
	card_itens.add_child(tdbox)
	card.add_child(card_itens)


	tboxdic = {
		'number': table_num,
		'name': Tname.text,
		'pic': [r,g,b],
		'desc': 'none'
	}

	f.open(fpath, File.WRITE)
	txtparse.push_back(tboxdic)
#	tboxlist.push_back(txtparse))
	f.store_string(to_json(txtparse))
	f.close()
	print('Table List File updated... \n')
	

#	update_list_json()
	
	table_list.add_child(card)
	table_num += 1
	print("Esse é o novo Table_Num 000: ", table_num)

