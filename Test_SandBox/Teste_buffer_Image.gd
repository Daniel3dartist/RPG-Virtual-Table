extends Node2D


func _input(event):
	if Input.is_action_just_pressed("enter"):
		change_texture()

func change_texture():
	#$Sprite.texture = load_external_tex("C:/Users/Daniel/Downloads/png-clipart-orc-orc-thumbnail.png")
	$Sprite.texture = load_external_tex("C:/Users/Daniel/Documents/Godot/Godot_V3.5.1/data/Tables/Table/Sheets/Sheet(3)/Char_Image.png")
#	$TextureRect.texture = load_external_tex("C:/Users/Daniel/Documents/Godot/Godot_V3.5.1/data/Tables/Table/Sheets/Sheet(3)/Char_Image.png")
	$TextureRect.material.set_shader_param('tex_frg_2' , load_external_tex("C:/Users/Daniel/Documents/Godot/Godot_V3.5.1/data/Tables/Table/Sheets/Sheet(3)/Char_Image.png"))
	#C:/Users/Daniel/Documents/Godot/Godot_V3.5.1/data/Tables/Table/Sheets/Sheet(3)

func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex
