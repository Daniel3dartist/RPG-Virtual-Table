extends TextureRect

onready var check_box = self.get_parent().get_node("CheckBox")
onready var label_is_checked = $"../CheckBox/is_checked"

var is_check : bool = true
var token_param : Dictionary = {
	'ring_color': '',
	'uv_scale': [0.0, 0.0],
	'uv_offset': [0.0, 0.0],
	'checkbox': true,
}



func _ready():
	var char_sheet = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	if label_is_checked.text == 'true':
		is_check = true
	elif label_is_checked.text == 'false':
		is_check = false
	else:
		pass
	check_box.pressed = is_check



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
	label_is_checked.text = 'true'


func _on_CheckBox_button_up():
	is_check = false
	label_is_checked.text = 'false'


func _on_ColorPickerButton_color_changed(color):
	self.material.set_shader_param('outline_color' , color)
	token_param['ring_color'] = color

