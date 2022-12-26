extends Control

var BASE_PATH 
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
var dragging = false
var click_radius = 450
var off_set
var pos
onready var pos2d = self.get_node('CanvasLayer/Node2D')

# Base Image for Char
onready var base_Char_Image = preload('res://Base_Images/Char_Base_Image.png')

signal give_data(index)


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
	var table = self.get_parent().get_parent()
	table.connect('receive_sheet_data', self, '_Receive_Sheet_Data')
	emit_signal("give_data", self.get_index())
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
		_Update_Save()


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
		_Update_Save()

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
		_Update_Save()

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
		_Update_Save()

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
		_Update_Save()

# Drag-and-drop sheet
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		off_set = [rect_position - get_global_mouse_position(), get_node("CanvasLayer/ColorRect2").rect_position - get_global_mouse_position()]
#		pos = pos2d.position - rect_position
#		if (event.position - pos2d.position).length() <= click_radius:
#		if rect_size.length() <= click_radius:
#			if not dragging and event.pressed:
#				dragging = true
#			if dragging and not event.pressed:
#				dragging = false

		var area = get_node("CanvasLayer/ColorRect2").rect_size
		var mouse = get_global_mouse_position()
#		var dic = {
#			'min_x': self.get_node("CanvasLayer/Node2D/ColorRect2").rect_position.x - (area.x/2),
#			'max_x': self.get_node("CanvasLayer/Node2D/ColorRect2").rect_position.x + (area.x/2),
#			'min_y': self.get_node("CanvasLayer/Node2D/ColorRect2").rect_position.y - (area.y/2),
#			'max_y': self.get_node("CanvasLayer/Node2D/ColorRect2").rect_position.y + (area.y/2)
#		}
#		var dic = {
#			'min_x': self.get_node("CanvasLayer/ColorRect2").rect_position.x - (area.x/2),
#			'max_x': self.get_node("CanvasLayer/ColorRect2").rect_position.x + (area.x/2),
#			'min_y': self.get_node("CanvasLayer/ColorRect2").rect_position.y - (area.y/2),
#			'max_y': self.get_node("CanvasLayer/ColorRect2").rect_position.y + (area.y/2)
#		}
		var dic = {
			'min_x': self.get_node("CanvasLayer/ColorRect2").margin_left,
			'max_x': self.get_node("CanvasLayer/ColorRect2").margin_right,
			'min_y': self.get_node("CanvasLayer/ColorRect2").margin_top,
			'max_y': self.get_node("CanvasLayer/ColorRect2").margin_bottom
		}
		if mouse.x >= dic['min_x'] and mouse.x <= dic['max_x'] and mouse.y >= dic['min_y'] and mouse.y <= dic['max_y']:
			print('Is mouse position\n')
			set_default_cursor_shape(13)
			dragging = true
	if Input.is_action_just_released("left_mouse"):
		dragging = false

func _process(delta):
#	 if self.get_node('Position2D').intersect_shape(get_viewport().get_mouse_position()):
#		pass

	var area = get_node("CanvasLayer/ColorRect2").rect_size
	var mouse = get_global_mouse_position()
	var dic = {
		'min_x': self.get_node("CanvasLayer/ColorRect2").margin_left,
		'max_x': self.get_node("CanvasLayer/ColorRect2").margin_right,
		'min_y': self.get_node("CanvasLayer/ColorRect2").margin_top,
		'max_y': self.get_node("CanvasLayer/ColorRect2").margin_bottom
	}
	if mouse.x >= dic['min_x'] and mouse.x <= dic['max_x'] and mouse.y >= dic['min_y'] and mouse.y <= dic['max_y']:
		print('Is mouse position\n')

	
	if dragging == true:
		
		var view = get_viewport().get_mouse_position()
		rect_position = view + off_set[0]
		pos2d.position = pos2d.position - rect_position #rect_position + pos
		get_node("CanvasLayer/ColorRect2").rect_position = view + off_set[1]


func _on_Sheet_Exit_button_up():
	self.queue_free()


func _Receive_Sheet_Data(data_path):
	sheet = {
		'data': '',
		'path': data_path,
	}
	print('Data recebido ', data_path)



func _Initialize_Sheet():
	var sheet_save = ConfigFile.new()
	var err
	var core_status
	
	var strtxt = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/STR_Input')
	var dextxt = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/DEX_Input')
	var contxt = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/CON_Input')
	var inttxt = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/INT_Input')
	var wistxt = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/WIS_Input')
	var chatxt = self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/CHA_Input')

	err = sheet_save.load(str(sheet['path']))
	if err != OK:
		print('Erro when try to load sheet data...')
	else:
		if self.get_node('ColorRect/SheetArea/CharacterBaseArea/CharacterName_BoxC/Character_Name').text == '':
			self.get_node('ColorRect/SheetArea/CharacterBaseArea/CharacterName_BoxC/Character_Name').text = sheet_save.get_value("Sheet", "Name")
			print('config: ', sheet_save.get_value("Sheet", "Name"))
			
			core_status = sheet_save.get_value("Status", "core status")
			print(core_status)
			if core_status != null:
				strtxt.text = str(core_status['str'])
				dextxt.text = str(core_status['dex'])
				contxt.text = str(core_status['con'])
				inttxt.text = str(core_status['int'])
				wistxt.text = str(core_status['wis'])
				chatxt.text = str(core_status['cha'])
			else:
				_Update_Save()
		# Verify if character sheet has a image
		if sheet_save.get_value('Character_Image', 'Image') == null or sheet_save.get_value('Character_Image', 'Image') == '':
			self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/TextureRect').material.set_shader_param('tex_frg_2' , base_Char_Image)
			self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/Label').visible = true
		else:
			char_image = load(sheet_save.get_value('Character_Image', 'Image'))
			self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/TextureRect').material.set_shader_param('tex_frg_2' , char_image)
			self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/Label').visible = false

func _Update_Save():
	var sheet_save = ConfigFile.new()
	var err
	var txt = self.get_node('ColorRect/SheetArea/CharacterBaseArea/CharacterName_BoxC/Character_Name').text
#	print(sheet['path'])
	err = sheet_save.load(sheet['path'])
	if err != OK:
		print('Erro when try to load sheet data...')
		pass
	else:
		if char_image == null or char_image == '':
			sheet_save.set_value('Character_Image', 'Image', base_Char_Image)
	
	sheet_save.set_value('Sheet', 'Name', txt )
	sheet_save.set_value('Status', 'core status', core_status )
	sheet_save.set_value('Character_Image', 'Image', char_image)
	sheet_save.save(sheet['path'])



#func _on_Area2D_mouse_entered():
#	print('Mouse entered')
#	off_set = self.rect_position - get_global_mouse_position()
#	if Input.is_action_pressed("left_mouse"):
#		dragging = true


#func _on_Area2D_mouse_exited():
#	if Input.is_action_just_released("left_mouse"):
#		dragging = false

# Receive Character image from user
func _on_TextureRect_char_image_path(path):
	var PATH = path
	var dir = sheet['path']
	var sheet_name = dir
	var image_name
	
	sheet_name = sheet_name.split('/')
	sheet_name = '/' + sheet_name[-1]
	dir = dir.substr(0, dir.length() - sheet_name.length())
	PATH = PATH.replace('\\','/')
	image_name = PATH.split('.')
	image_name = '/Char_Image.' + image_name[-1]
	dir = dir + image_name
	Directory.new().copy(PATH, dir)
	char_image = dir
	_Update_Save()
	self.get_node('ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/TextureRect').material.set_shader_param('tex_frg_2' , load(char_image))


