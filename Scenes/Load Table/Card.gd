extends HBoxContainer

signal delet_table(value)
signal playscene(index)

func _on_Delete_Table_button_up():
	emit_signal("delet_table", self.get_index())
	print('Delete_table signal emited...')
	self.queue_free()


func _on_Edit_Table_button_up():
	pass # Replace with function body.


func _on_Play_Scene_button_up():
	var _name = $"Table Description/Table_desc_itens/Table Name".text
	var path = "res://Scenes/Table/Table.tscn"
	var save_path = OS.get_executable_path().get_base_dir() + '/data/Tables/%s/%s.ini' % [_name, _name] 
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
