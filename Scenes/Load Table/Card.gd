extends HBoxContainer

var BASE_PATH =  OS.get_executable_path().get_base_dir()

signal delete_table(value)
signal playscene(index)
signal save_changes(value)

onready var name_line = $"Table Description/Table_desc_itens/Table Name"
onready var txt_edit = $"Table Description/Table_desc_itens/TextEdit"
onready var play_button = $"Table Description/Table_desc_itens/HBoxContainer/Play_Scene"
onready var save_button = $"Table Description/Table_desc_itens/HBoxContainer/Save"

onready var system_name = $"Table Description/Table_desc_itens/HBoxContainer/System_name"
onready var panel_menubutton = $"Table Description/Table_desc_itens/HBoxContainer/Panel"
onready var menubutton = $'Table Description/Table_desc_itens/HBoxContainer/Panel/MenuButton'

func _ready():
	var popup = menubutton.get_popup()
	popup.connect("id_pressed", self, "Popup_id_pressed")


func _on_Delete_Table_button_up():
	emit_signal("delete_table", self.get_index())
	print('Delete_table signal emited...')
#	self.queue_free()


func _on_Edit_Table_button_up():
	name_line.editable = true
	txt_edit.readonly = false
	play_button.visible = false
	save_button.visible = true
	system_name.visible = false
	panel_menubutton.visible = true


func _on_Save_button_up():
	var _name = name_line.text
	var dic : Dictionary = {
		'id': self.get_index(),
		'name': name_line.text,
		'desc': txt_edit.text,
		'path': BASE_PATH + '/data/Tables/%s' % _name,
		'system': menubutton.text
		}
	
	name_line.editable = false
	txt_edit.readonly = true
	play_button.visible = true
	save_button.visible = false
	system_name.text = menubutton.text
	panel_menubutton.visible = false
	system_name.visible = true
	
	var config = ConfigFile.new()
	var save_path = BASE_PATH + '/data/Tables/%s/%s.ini' % [_name, _name] 
	config.set_value('Last Played', 'name', _name)
	config.set_value('Last Played', 'path', save_path)
	config.set_value('Last Played', 'system', menubutton.text)
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
	config.set_value('Table', 'system', menubutton.text)
	config.save(save_path)

	
	var config2 = ConfigFile.new()
	config2.set_value('Last Played', 'name', _name)
	config2.set_value('Last Played', 'path', save_path)
	config2.set_value('Last Played', 'system', menubutton.text)
	config2.save(OS.get_executable_path().get_base_dir() + '/data/last_played.ini')
	get_tree().change_scene(path)
	

func Popup_id_pressed(id):
#var popup = $'Table Description/Table_desc_itens/HBoxContainer/Panel/MenuButton'
	match id:
		0:
			menubutton.text = menubutton.get_popup().get_item_text(id)
		1:
			menubutton.text = menubutton.get_popup().get_item_text(id)
		2:
			menubutton.text = menubutton.get_popup().get_item_text(id)
		3:
			menubutton.text = menubutton.get_popup().get_item_text(id)
		4:
			menubutton.text = menubutton.get_popup().get_item_text(id)
		5: 
			menubutton.text = menubutton.get_popup().get_item_text(id)
