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
var exe_path = OS.get_executable_path().get_base_dir()
var BASE_PATH = OS.get_executable_path().get_base_dir() + '/data/table_list.ini'  
var main_menu = 'res://Scenes/Main Menu.tscn'

# Number of table created
var table_num: int = 0
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
var tboxlist : Array = []

# Default scenes to add
var tcard = preload('res://Scenes/Load Table/Card.tscn')

# Place to list the tables
onready var table_list = $'ColorRect/VBoxContainer/VBoxContainer/ScrollContainer/Table List'

var next

func _ready():
	print("Fpath: ", BASE_PATH)
	var cfg = ConfigFile.new()
	var txtparse
	var size
	var sz = 0
	
	cfg.load(BASE_PATH)
	check_if_Table_List_File_Exist()
	var array = cfg.get_value('Tables', 'table_list')
	if array != null:
		tboxlist = array
		for i in array:
			var card = tcard.instance()
			table_list.add_child(card)
			
			card.connect('playscene', self, '_play_scene')
			card.connect('save_changes', self, '_Save_Changes')
			
			card = table_list.get_child(sz)
			card.get_node('Table Description/Table_desc_itens/Table Name').text = array[sz]['name']
			card.get_node('Table Description/Table_desc_itens/TextEdit').text = array[sz]['desc']
			
			var _texture = Texture.new()
			var _material = ShaderMaterial.new()
			var _shader = Shader.new()
			var dice_tex = load("res://Base_Images/Table_Base_Image_d6_%s.png" % array[sz]['pic']['dice'])
			_texture = dice_tex
			_shader = load("res://Scenes/Load Table/Card.gdshader")
			_material.shader = _shader
			card.get_node('TextureRect').texture = _texture
			card.get_node('TextureRect').material = _material
			card.get_node('TextureRect').material.set_shader_param('Dice_Tex', dice_tex)
			card.get_node('TextureRect').material.set_shader_param('color', array[sz]['pic']['rgb'])
			card.get_node('TextureRect').material.set_shader_param('alpha', 0.0)
			
			sz += 1
			table_num += 1

func _on_Main_Menu_button_up():
	get_tree().change_scene(main_menu)


func _on_Add_a_New_Table_button_up():
	add_table()


func Creat_Table_List():
	var cfg = ConfigFile.new()
	cfg.set_value('Tables', 'table_list', [])
	cfg.save(BASE_PATH)
	table_num = 0
	print('Table List File Created... \n')
	Check_Table_Dir()


func check_if_Table_List_File_Exist():
	var f = File.new()
	
	f = f.file_exists(BASE_PATH)
	if f != true:
		Creat_Table_List()
	else:
		Check_Table_Dir()
		print('Table List File exist... \n')

func Check_Table_Dir():
	var dir = Directory.new()
	var path = exe_path + '/data/Tables'
	
	if not dir.dir_exists(path):
		dir.make_dir(path)


func organize_the_table_list(value):
	var f = File.new()
	
	var txt = 'Table'
	var txtparse
	var keysn
	var card = tcard.instance()


func add_table():
	var dir = Directory.new()

	var txt = 'Table'
	var txtparse
	
	var r = randf() + randf()
	var g = randf() + randf()
	var b = randf() + randf()
	
	for i in table_num:
		r = randf() + randf()
		g = randf() + randf()
		b = randf() + randf()
	
	var dice = randi() % 6 + 1
	
	var card = tcard.instance()

	if table_num != 0 :
		txt = txt + ('(%s)' % str(table_num))
		
	card.get_node("Table Description/Table_desc_itens/Table Name").text = txt
#	card. = Color(r, g, b)


#	card.connect('delet_table', self, '_delete_table')
#	BplaySc.connect('playscene', self, '_play_scene')
	var card_pic : Dictionary = {
				'dice': str(dice),
				'rgb' : Vector3(r,g,b),
				}

	tboxdic = {
		'number': table_num,
		'name': card.get_node("Table Description/Table_desc_itens/Table Name").text,
		'pic': card_pic,
		'desc': 'none',
		'path': '%s/data/Tables/%s' % [exe_path, txt]
	}
	print('Table List File updated... \n')
	
	table_list.add_child(card)
	card = table_list.get_child(table_num)
	dice = str(dice)
	var _path = "res://Base_Images/Table_Base_Image_d6_%s.png" % dice
	var dice_pic = load(_path)

	card.get_node("Table Description/Table_desc_itens/Table Name").text = txt
	var tex = card.get_node("TextureRect")
	var _material = ShaderMaterial.new()
	var _shader = Shader.new()
	_shader = load("res://Scenes/Load Table/Card.gdshader")
	_material.shader = _shader
	tex.material = _material
#	tex.texture = Texture.new().load("res://Base_Images/Table_Base_Image_d6_6.png")
	tex.material.set_shader_param('Dice_Tex', dice_pic)
	tex.material.set_shader_param('color', Vector3(r,g,b))
	card.connect('playscene', self, '_play_scene')
	card.connect('save_changes', self, '_Save_Changes')
	
	dir.make_dir(tboxdic['path'])
	
	var cfg = ConfigFile.new()
	tboxlist.push_back(tboxdic)
	cfg.set_value('Tables', 'table_list', tboxlist)
	cfg.save(BASE_PATH)
	
	table_num += 1
#	tboxlist = txtparse


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


func _Save_Changes(dic):
	var dir = Directory.new()
	var cfg = ConfigFile.new()
	var old_dic : Dictionary = {
		'name': tboxlist[dic['id']]['name'],
		'num': tboxlist[dic['id']]['number'],
		'dir': exe_path + '/data/tables/%s' % tboxlist[dic['id']]['name'],
		'path': tboxlist[dic['id']]['path']
	}
	
	dir.rename(exe_path + '/data/tables/%s' % old_dic['name'], dic['path'])
	dir.rename(exe_path + '/data/tables/%s/%s.ini' % [dic['name'], old_dic['name']], exe_path + '/data/tables/%s/%s.ini' % [dic['name'], dic['name']])
#	dir.rename(exe_path + '/data/tables/table(1)', exe_path + '/data/tables/Julinhos02')
	
	tboxlist[dic['id']]['name'] = dic['name']
	tboxlist[dic['id']]['desc'] = dic['desc']
	tboxlist[dic['id']]['path'] = dic['path']

	cfg.load(BASE_PATH)
	cfg.set_value('Tables', 'table_list', tboxlist)
	cfg.save(BASE_PATH)

#tboxdic = {
#	'number': '',
#	'name': '',
#	'pic': '',
#	'desc': '',
#	'path': ''}

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



