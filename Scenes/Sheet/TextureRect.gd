extends TextureRect


func _ready():
	var char_sheet = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	char_sheet.connect('load_image_token', self, "_Load_Image_Token")

func _Load_Image_Token(img):
	self.texture = img
	self.material.set_shader_param('tex_frg_2', img)
	
func load_char_image(path):
	var TexRect = $'ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/TextureRect'
	var Token = $'ColorRect/SheetArea/Sheet_TabContainer/Token/CenterContainer/TextureRect'
	var valid_image = load_external_tex(path)
	
	$'ColorRect/SheetArea/Sheet_TabContainer/Background/HBoxContainer/CenterContainer/Label'.visible = false
	TexRect.texture = valid_image
	TexRect.material.set_shader_param('tex_frg_7' , valid_image)
	TexRect.material.set_shader_param('alpha', 1.000)
	Token.material.set_shader_param('tex_frg_2' , valid_image)
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
