extends HBoxContainer

var BASE_PATH =  OS.get_executable_path().get_base_dir()

signal delet_table(value)
signal playscene(index)
signal save_changes(value)

onready var name_line = $"Table Description/Table_desc_itens/Table Name"
onready var txt_edit = $"Table Description/Table_desc_itens/TextEdit"
onready var play_buttom = $"Table Description/Table_desc_itens/HBoxContainer/Play_Scene"
onready var save_buttom = $"Table Description/Table_desc_itens/HBoxContainer/Save"

func _on_Delete_Table_button_up():
	emit_signal("delet_table", self.get_index())
	print('Delete_table signal emited...')
	self.queue_free()


func _on_Edit_Table_button_up():
	name_line.editable = true
	txt_edit.readonly = false

	play_buttom.visible = false
	save_buttom.visible = true


func _on_Save_button_up():
	var _name = name_line.text
	var dic : Dictionary = {
		'id': self.get_index(),
		'name': name_line.text,
		'desc': txt_edit.text,
		'path': BASE_PATH + '/data/Tables/%s' % _name
		}
	
	name_line.editable = false
	txt_edit.readonly = true

	play_buttom.visible = true
	save_buttom.visible = false
	
	var config = ConfigFile.new()
	var save_path = BASE_PATH + '/data/Tables/%s/%s.ini' % [_name, _name] 
	config.set_value('Last Played', 'name', _name)
	config.set_value('Last Played', 'path', save_path)
	config.save(OS.get_executable_path().get_base_dir() + '/data/last_played.ini')
	
	emit_signal('save_changes', dic)


func _on_Play_Scene_button_up():
	var _name = name_line.text
	var path = "res://Scenes/Table/Table.tscn"
	var save_path = BASE_PATH + '/data/Tables/%s/%s.ini' % [_name, _name] 
	print('\n\nSAVE_PATH: ', save_path, '\n\n')
	var config = ConfigFile.new()
	
	config.load(save_path)
	config.set_value('Table', 'name', _name)
	config.save(save_path)

	
	var config2 = ConfigFile.new()
	config2.set_value('Last Played', 'name', _name)
	config2.set_value('Last Played', 'path', save_path)
	config2.save(OS.get_executable_path().get_base_dir() + '/data/last_played.ini')
		
	get_tree().change_scene(path)

