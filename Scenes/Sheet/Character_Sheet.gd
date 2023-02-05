extends Control

signal give_index(value)

onready var BASE_PATH
onready var sheet_list_path = self.get_parent().get_parent().get_node('Base_UI/Chat_&_Rolls_Results/TabContainer/SheetList/ScrollContainer/VBoxContainer')
var old_name : String
var _index : int = 0
var sheet
var core_status= {
		'str' : 10,
		'dex': 10,
		'con': 10,
		'int': 10,
		'wis': 10,
		'cha': 10,
	}
var char_image = ''
var player_color

# Drag-and-drop vars
var dragging: bool = false
var is_block: bool = true
var click_radius = 450
var off_set
var pos

onready var pos2d = self.get_node('CanvasLayer/Node2D')
onready var color_rect = self.get_node("CanvasLayer/ColorRect2")

# Base Image for Char
onready var base_Char_Image = preload('res://Base_Images/Char_Base_Image.png')
onready var token_base_Char_Image = preload('res://Base_Images/Char_Base_Image_300x300p.png')
onready var checkbox = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer/HBoxContainer2/CheckBox')
# Token parameters
var token_param : Dictionary = {
	'ring_color': Color('#596b6f'),
	'uv_scale': [1.0, 1.0],
	'uv_offset': [0.0, 0.0],
	'checkbox': true,
}

onready var scale_x = $'ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer/X_Scale_Input/X_Scale_Input_HSlider'
onready var scale_y = $'ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer/HBoxContainer2/Y_Scale_Input/Y_Scale_Input_VSlider'
onready var offset_x = $'ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer/X_Position_Input/X_Position_Input_HSlider'
onready var offset_y = $'ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer/HBoxContainer2/Y_Position_Input/Y_Position_Input_VSlider'
onready var color = $'ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer3/VBoxContainer/CenterContainer/ColorPickerButton'


signal give_data(index)
signal load_image_token(img)

# ===============================================[ Character id var ]============================================================= #

onready var char_name = $'ColorRect/SheetArea/CharacterBaseArea/CharacterName_BoxC/Character_Name'
onready var char_race =  $'ColorRect/SheetArea/CharacterBaseArea/CharacterRace_BoxC/Character_Race'
onready var char_class = $'ColorRect/SheetArea/CharacterBaseArea/CharacterClass_BoxC/Character_Class'

# ===============================================[ Score Attributes var ]============================================================= #

# Inputs values
onready var STR_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/STR_Input'
onready var DEX_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/DEX_Input'
onready var CON_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/CON_Input'
onready var INT_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/INT_Input'
onready var WIS_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/WIS_Input'
onready var CHA_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/CHA_Input'

# Mods Values
onready var STR_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/STR_Mod_Value'
onready var DEX_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/DEX_Mod_Value'
onready var CON_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/CON_Mod_Value'
onready var INT_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/INT_Mod_Value'
onready var WIS_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/WIS_Mod_Value'
onready var CHA_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/CHA_Mod_Value'


func _ready():
#	print('get center: %s' % get_node("CanvasLayer/Node2D/ColorRect2").rect_position)
	old_name = char_name.text
	$'ColorRect'.rect_position = Vector2(140, 60)
	color_rect.rect_position = Vector2(235-15, 60)
	color_rect.connect("mouse_entered", self, "Mouse_Entered")
	color_rect.connect("mouse_exited", self, "Mouse_Exited")
	var table = self.get_parent().get_parent()
	print('\n\n Parente Parente: %s\n\n' % table)
	table.connect('receive_sheet_data', self, '_Receive_Sheet_Data')
	table.connect('index', self, '_Index')
	emit_signal("give_data")
	print('Starting Sheet...')
	_Initialize_Sheet()
	

func _input(event):
	# STR
	var strDefault = int(STR_Input.text)
	var strCompareNum = 10	
	# DEX
	var dexDefault = int(DEX_Input.text)
	var dexCompareNum = 10
	# CON
	var conDefault = int(CON_Input.text)
	var conCompareNum = 10	
	# INT
	var intDefault = int(INT_Input.text)
	var intCompareNum = 10	
	# WIS
	var wisDefault = int(WIS_Input.text)
	var wisCompareNum = 10
	# CHA
	var chaDefault = int(CHA_Input.text)
	var chaCompareNum = 10



	# STR Mod Input
	if strDefault != strCompareNum:
		var strMod
		var num


		num = int(STR_Input.text)
		strMod = num
		core_status['str'] = num
		strMod = str((strMod - 10) / 2)
		STR_Mod_Value.text = strMod
		strCompareNum = num


	# DEX Mod Input
	if dexDefault != dexCompareNum:
		var dexMod
		var num
		num = int(DEX_Input.text)
		core_status['dex'] = num
		dexMod = num
		dexMod = str((dexMod - 10) / 2)
		DEX_Mod_Value.text = dexMod
		dexCompareNum = num
	#	_Update_Save()


	# CON Mod Input
	if conDefault != conCompareNum:
		var conMod
		var num

		num = int(CON_Input.text)
		core_status['con'] = num
		conMod = num
		conMod = str((conMod - 10) / 2)
		CON_Mod_Value.text =conMod
		conCompareNum = num
	#	_Update_Save()

	# INT Mod Input
	if intDefault != intCompareNum:
		var intMod
		var num

		num = int(INT_Input.text)
		core_status['int'] = num
		intMod = num
		intMod = str((intMod - 10) / 2)
		INT_Mod_Value.text = intMod
		intCompareNum = num
	#	_Update_Save()

	# WIS Mod Input
	if wisDefault != wisCompareNum:
		var wisMod
		var num

		num = int(WIS_Input.text)
		core_status['wis'] = num
		wisMod = num
		wisMod = str((wisMod - 10) / 2)
		WIS_Mod_Value.text =wisMod
		wisCompareNum = num
	#	_Update_Save()

	# CHA Mod Input
	if chaDefault != chaCompareNum:
		var chaMod
		var num

		num = int(CHA_Input.text)
		core_status['cha'] = num
		chaMod = num
		chaMod = str((chaMod - 10) / 2)
		CHA_Mod_Value.text = chaMod
		chaCompareNum = num
	#	_Update_Save()

# Drag-and-drop sheet
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		off_set = [rect_position - get_global_mouse_position(), color_rect.rect_position - get_global_mouse_position()]

		var area = color_rect.rect_size
		var mouse = get_global_mouse_position()
		
		if is_block == false:
			print('Is mouse position\n')
			set_default_cursor_shape(13)
			dragging = true
	if Input.is_action_just_released("left_mouse"):
		dragging = false

func _process(delta):
	var area = color_rect.rect_size
	var mouse = get_global_mouse_position()
	
	if dragging == true:
		var view = get_viewport().get_mouse_position()
		rect_position = view + off_set[0]
		pos2d.position = pos2d.position - rect_position #rect_position + pos
		color_rect.rect_position = view + off_set[1]


# Check if mouse isn't over anoter UI node. If so, the dragging command will be blocked.
func Mouse_Entered(): # Free to dragging
	is_block = false

func Mouse_Exited(): # Blocked to dragging
	is_block = true

# Close the sheet UI
func _on_Sheet_Exit_button_up():
	self.queue_free()


func _Receive_Sheet_Data(dic):
	sheet = dic
	print('\n\nData recebido %s\n\n' % sheet)


# start I/O data check and load
func _Initialize_Sheet():
	var txt_input_array = [STR_Input, DEX_Input, CON_Input, INT_Input, WIS_Input, CHA_Input, char_name, char_race, char_class]
	
#	if char_name.text == '' or char_name.text == null:
	#	char_name.text = sheet['name']

	for i in txt_input_array.size():
		txt_input_array[i].text += ''
	pass


# save edits
func _Update_Save():
	var packed_scene = PackedScene.new()
	var _name = old_name
	var dir = Directory.new()
	var buttom = sheet_list_path.get_child(sheet['id']).get_child(1)
	var path_label = sheet_list_path.get_child(sheet['id']).get_child(2)
	var old_path = path_label.text
	var txt = path_label.text
	print('\n\nPath_Label: \n', txt.replace('%s.tscn'%buttom.text, '%s.tscn'% 'maria'))
	old_name = buttom.text
	var sub = txt.find_last('Sheets')
	var knum = 'Sheets'.length()

	if old_name != char_name.text:
		_name = char_name.text +'.tscn' 
		if buttom.text == old_name:
			buttom.text = char_name.text
			old_path = path_label.text
			old_name = buttom.text + '.tscn'
			print(txt)
			txt = txt.substr(0, sub + knum)
			txt = txt + '/%s' % _name
#			var list = '/'.join(txt)
#			print('list: ',list)
#			path_label.text = txt 
			print('\n\nOld: \n', old_path, '\n\nNew: \n', _name,'\n\n', txt)
	dir = txt
	buttom.text = char_name.text
	path_label.text = dir
	print('\nTXT:', dir)
	Directory.new().rename(str(old_path), str(path_label.text))
	packed_scene.pack(self)
	ResourceSaver.save(dir, packed_scene)
	pass

# ===============================================[ Load Texture Image of Player Character ]============================================================= #

# Receive Character image from user
func _on_TextureRect_char_image_path(path):
	var PATH = path
	var image_name
	image_name = PATH.split('/')
	image_name = '/%s' % image_name[-1]
	print('\n\nImage_name\n\n', image_name, '\n\n')
	char_image = PATH
	load_char_image(PATH)
	

func load_char_image(path):
	var TexRect = $'ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/TextureRect'
	var Token = $'ColorRect/SheetArea/Sheet_TabContainer/Token/HBoxContainer/VBoxContainer/HBoxContainer2/Token_TextureRect'
	var valid_image = load_external_tex(path)
#	char_image = valid_image
	
	$'ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/Label'.visible = false
	TexRect.texture = valid_image
	TexRect.material.set_shader_param('tex_frg_7' , valid_image)
	TexRect.material.set_shader_param('alpha', 1.000)
	Token.material.set_shader_param('tex_frg_2' , valid_image)
#	_Update_Save()
	print('\n\nChar_Image: ', char_image, '\n\n')
#	emit_signal('load_image_token', valid_image)


func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data 
	var file_type = path.split('.')
	var is_valid: bool = true
	
	if file_type[-1] == 'png':
		data = img.load_png_from_buffer(bytes)
	elif file_type[-1] == 'jpg' or  file_type[-1] == 'jpeg':
		data = img.load_jpg_from_buffer(bytes)
	elif file_type[-1] == 'bmp':
		data = img.load_bmp_from_buffer(bytes)
	elif file_type[-1] == 'tga':
		data = img.load_tga_from_buffer(bytes)
	elif file_type[-1] == 'webp':
		data = img.load_webp_from_buffer(bytes)
	else:
		is_valid = false
		print('\nErro to load character image file. \nUse a valid image file format\n')
	
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	
	return imgtex



func _on_Token_TextureRect_save_token_param(dict):
	token_param = dict
	print(token_param)
#	_Update_Save()


func _on_Save_Button_pressed():
	_Update_Save()


func _Index(value):
	_index = value
	print('\n\nIndex: ', value, '\n\n')
