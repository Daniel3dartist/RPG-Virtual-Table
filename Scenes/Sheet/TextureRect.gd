extends TextureRect

onready var check_box = self.get_parent().get_node("CheckBox")
var is_check : bool = true
var token_param : Dictionary = {
	'ring_color': '',
	'uv_scale': [0.0, 0.0],
	'uv_offset': [0.0, 0.0],
}

signal save_token_param(dict)

func _ready():
	var char_sheet = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	check_box.pressed = is_check
	char_sheet.connect('load_image_token', self, "_Load_Image_Token")

func _Load_Image_Token(img):
	self.texture = img
	self.material.set_shader_param('tex_frg_2', img)
	
func load_char_image(path):
	var TexRect = $'ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/TextureRect'
	var valid_image = load_external_tex(path)
	
	$'ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/Label'.visible = false
	TexRect.texture = valid_image
	TexRect.material.set_shader_param('tex_frg_7' , valid_image)
#	TexRect.material.set_shader_param('alpha', 1.000)
	self.material.set_shader_param('tex_frg_2' , valid_image)
	emit_signal('load_image_token', valid_image)


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


func save_token_param():
	emit_signal("save_token_param", token_param)


func _on_X_Scale_Input_HSlider_value_changed(value):
	var y_scale = self.get_parent().get_parent().get_node("HBoxContainer2/Y_Scale_Input/Y_Scale_Input_VSlider")
	
	self.material.set_shader_param('uvs_x' , value)
	token_param['uv_scale'][0] = value
	if is_check == true:
		self.material.set_shader_param('uvs_y' , value)
		token_param['uv_scale'][1] = value
		y_scale.value = value



func _on_Y_Scale_Input_VSlider_value_changed(value):
	var x_scale = self.get_parent().get_parent().get_node("X_Scale_Input/X_Scale_Input_HSlider")
	self.material.set_shader_param('uvs_y' , value)
	token_param['uv_scale'][1] = value
	if is_check == true:
		self.material.set_shader_param('uvs_x' , value)
		token_param['uv_scale'][0] = value
		x_scale.value = value


func _on_Y_Position_Input_VSlider_value_changed(value):
	self.material.set_shader_param('uvm_y' , value)
	token_param['uv_offset'][0] = value


func _on_X_Position_Input_HSlider_value_changed(value):
	self.material.set_shader_param('uvm_x' , value)
	token_param['uv_offset'][1] = value


func _on_CheckBox_button_down():
	is_check = true


func _on_CheckBox_button_up():
	is_check = false


func _on_ColorPickerButton_color_changed(color):
	self.material.set_shader_param('outline_color' , color)
	token_param['ring_color'] = color


func _on_X_Scale_Input_HSlider_drag_ended(value_changed):
	save_token_param()


func _on_Y_Scale_Input_VSlider_drag_ended(value_changed):
	save_token_param()



func _on_Y_Position_Input_VSlider_drag_ended(value_changed):
	save_token_param()


func _on_X_Position_Input_HSlider_drag_ended(value_changed):
	save_token_param()


func _on_ColorPickerButton_popup_closed():
	save_token_param()


func _on_CheckBox_toggled(button_pressed):
	save_token_param()
