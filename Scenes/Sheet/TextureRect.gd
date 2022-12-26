extends TextureRect


func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		var texture = load('res://Krita_Imagens/Alpha token prototype_Mask_Area.png')
#		print(self.ShaderMaterial.get_node_list())
		self.material.set_shader_param("tex_frg_2", texture)

	if Input.is_action_just_pressed("enter"):
		var texture = load('res://Krita_Imagens/Orc_do_Zé_01.jpg')
#		print(self.ShaderMaterial.get_node_list())
		self.material.set_shader_param("tex_frg_2", texture)

