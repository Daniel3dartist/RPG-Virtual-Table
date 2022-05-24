extends Control

var itens = []
var sub_itens = []
var item = {
	'name': '',
	'path': ''
}
var num = 0
var path


var t = true

var fpath = 'res://data/table_list.save'
var main_menu = 'res://Scenes/Main Menu.tscn'

# Number of table created
var table_num = 0
var num_of_tables 
var last_table = 0
var n = 0
var dkey

# Table dictionary of itens
var tboxdic = {
	'number': '',
	'name': '',
	'pic': '',
	'desc': '',
	'path': ''}

# List of table container saved
var tboxlist = []

# Default scenes to add
var add_table = preload("res://Scenes/Table/Table.tscn")
var table_description = preload("res://Scenes/Load Table/Table Description.tscn")
var table_name = preload("res://Scenes/Load Table/Table Name.tscn")
var table_color = preload("res://Scenes/Load Table/Table_color.tscn")
var table_desc_itens = preload("res://Scenes/Load Table/Table_desc_itens.tscn")
var tcard = preload('res://Scenes/Load Table/Card.tscn')
var play_scene_button = preload('res://Scenes/Load Table/Play_Scene_Button.tscn')
var txt_editor = preload('res://Scenes/Load Table/TextEdit.tscn')
var color_rec = preload('res://Scenes/Load Table/ColorRect.tscn')

# Place to list the tables
onready var table_list = $'ColorRect/VBoxContainer/VBoxContainer/ScrollContainer/Table List'

var next

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

func update_list_json():
	var f = File.new()
	var txtparse

	f.open(fpath, File.READ)
	txtparse = f.get_as_text()
	txtparse = parse_json(txtparse)
	txtparse.remove(dkey)
	
	f.open(fpath, File.WRITE)
	f.store_string(to_json(txtparse))
#	f.close
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
	var BplaySc = play_scene_button.instance()
	var txted = txt_editor.instance()
	var Crect = color_rec.instance()
	var Hcont = table_description.instance()

	f.open(fpath, File.READ)
	txtparse = f.get_as_text()
	txtparse = parse_json(txtparse)
	f.close()
	
#	print('Esse é a lista do NUM: ', txtparse[n])
	tboxlist = txtparse
	keysn = txtparse.size() #+ 1
	print('Keysn: ' , keysn)

	tdbox.add_child(Tname)
	#tdbox.add_child(Tname)
	tcolor.color = Color(txtparse[value]['pic'][0],txtparse[value]['pic'][1],txtparse[value]['pic'][2])
	Tname.text = txtparse[value]['name']
	card_itens.add_child(tcolor)
	Hcont.add_child(Crect)
	Hcont.add_child(BplaySc)
	tdbox.add_child(txted)
	tdbox.add_child(Hcont)
	card_itens.add_child(tdbox)
	card.add_child(card_itens)
	table_list.add_child(card)

	card.connect('delet_table', self, '_delete_table')
	BplaySc.connect('playscene', self, '_play_scene')

	print('This is Num: ' , value)
	print('This is Num: ', n)
	table_num = value + 1


func add_table():
	var f = File.new()
	var dir = Directory.new()
	
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
	var BplaySc = play_scene_button.instance()
	var txted = txt_editor.instance()
	var Crect = color_rec.instance()
	var Hcont = table_description.instance()

	tdbox.add_child(Tname)
	tcolor.color = Color(r, g, b)


	f.open(fpath, File.READ)
	txtparse = f.get_as_text()
	txtparse = parse_json(txtparse)
	tboxlist = txtparse
	f.close()
	if table_num != 0 :
		txt = txt + ('(%s)' % str(table_num))

	dir.open('res://data/Tables/')
	dir.make_dir(txt)

	Tname.text = str(txt) 
	card_itens.add_child(tcolor)
	Hcont.add_child(Crect)
	Hcont.add_child(BplaySc)
	tdbox.add_child(txted)
	tdbox.add_child(Hcont)
	card_itens.add_child(tdbox)
#	card_itens.add_child(BplaySc)
	card.add_child(card_itens)
	card.connect('delet_table', self, '_delete_table')
	BplaySc.connect('playscene', self, '_play_scene')


	tboxdic = {
		'number': table_num,
		'name': Tname.text,
		'pic': [r,g,b],
		'desc': 'none',
		'path': 'res://data/Tables/%s' % txt
	}

	f.open(fpath, File.WRITE)
	txtparse.push_back(tboxdic)
	f.store_string(to_json(txtparse))
	f.close()
	print('Table List File updated... \n')
	table_list.add_child(card)
	table_num += 1
	tboxlist = txtparse


func _delete_table(value):
#func get_itens():
	print('This is Value: ', tboxlist[value]['path'])
	var dir = Directory.new()
	path = tboxlist[value]['path']
	
	dir.open('%s/Sheets' % path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			print("Get File break\n")
			print("02525==> \nFiles: " , itens)
			break
		elif not file.begins_with("."):
			print("Search For files in dir...")
			print("Get file: %s \nFrom: %s\n" % [file , '%s/Sheets/%s' % [path, file] ])
			item = {
				'name': file,
				'path': '%s/Sheets/%s' % [path, file]
			}
#			item['name'] = file
#			item['path'] = '%s/Sheets/%s' % [path, file]
			itens.append(item)
	
	dir.list_dir_end()
	get_sub_itens()
	
#	dir.open('res://data/Tables')
	
	

func get_sub_itens():
	var dir2 = Directory.new()
	
	for i in itens.size():
		var it 
		if num <= itens.size():
			it = itens[num]
		if it != null:
			print('Path065065: ', itens[num]['name'])
			dir2.open(it['path'])
			print("\n\nCorrent Dir is: ", it['path'])
			num += 1
			dir2.list_dir_begin()
			while true:
				var file = dir2.get_next()
				if file == "":
					print("Get File break\n")
					print("06565==> \nFiles: " , sub_itens)
					break
				elif not file.begins_with("."):
					print("Search For files in dir...")
	#				print("Get file: %s \nFrom: %s\n" % [file , '%s/%s' % [it['path'], file] ])
					item = {
						'name': file,
						'path': '%s/%s' % [it['path'], file]
					}
	#				item['name'] = file
	#				item['path'] = '%s/%s' % [it['path'], file]
					if not sub_itens.has(item):
						sub_itens.append(item)
		
	dir2.list_dir_end()
#		print("06565==> \nFiles: " , sub_itens)
	var dn = 0
	for x in sub_itens.size():
		print("\n0878787==> \nFiles: " , sub_itens[dn], '\n')
		dn += 1
	delete_dir()

func delete_dir():
	var dir = Directory.new()
	while sub_itens.size() > 0:
		if dir.remove(sub_itens[0]['path']) == OK:
			sub_itens.remove(0)
		elif dir.remove(sub_itens[0]['path']) != OK:
			var temp = sub_itens[0]
			sub_itens.remove(0)
			sub_itens.push_back(temp)

	for i in itens.size():
		print('Itens print delete ', itens)
		dir.remove(itens[0]['path'])
		itens.remove(0)
	
	dir.remove('%s/Sheets' % path)
	dir.remove('C:/Users/Daniel/Documents/Godot Projects/RPG_Virtual_Table/data/Tables/Table' )

func _play_scene(index):
	var config = ConfigFile.new()
	var test = config.load('res://data/last_played.ini')
	var table = tboxlist[index]
	var parent = index
	
	print('Play get parent 01: ', parent)
	
	print('Play get parent 02: ', table)

	if test != OK:
		print("File 'last_played.ini' not found")
		
	config.set_value('Last Played', 'Last table', table)
	config.save('res://data/last_played.ini')

#	get_tree().change_scene('res://Scenes/Table/Table.tscn')
	get_tree().change_scene('res://Test_SandBox/Table_test.tscn')


