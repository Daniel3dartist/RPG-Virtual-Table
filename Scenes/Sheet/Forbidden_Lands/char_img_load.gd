extends Node

onready var TexRect = $"../Background/HBoxContainer/CenterContainer/TextureRect"
onready var Token = $"../Token/HBoxContainer/VBoxContainer/HBoxContainer2/Token_TextureRect"
onready var checkbox = $"../Token/HBoxContainer/VBoxContainer/HBoxContainer2/CheckBox"


# Receive Character image from user
func _on_TextureRect_char_image_path(path):
	var PATH = path
	var image_name
	image_name = PATH.split('/')
	image_name = '/%s' % image_name[-1]
	print('\n\nImage_name\n\n', image_name, '\n\n')
#	char_image = PATH
	load_char_image(PATH)
	

func load_char_image(path):
	var valid_image = load_external_tex(path)
	var label = $"../Background/HBoxContainer/CenterContainer/Label"
#	char_image = valid_image
	
	label.visible = false
	TexRect.texture = valid_image
	TexRect.material.set_shader_param('tex_frg_7' , valid_image)
	TexRect.material.set_shader_param('alpha', 1.000)
	Token.material.set_shader_param('tex_frg_2' , valid_image)
	checkbox.pressed = true
#	_Update_Save()
#	print('\n\nChar_Image: ', char_image, '\n\n')
#	emit_signal('load_image_token', valid_image)


func load_external_tex(path):
	var dir = Directory.new()
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
