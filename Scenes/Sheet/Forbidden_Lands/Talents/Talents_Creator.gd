extends Panel

signal receive_talent(_name, _class,rank,rank01, rank02, rank03)

func _ready():
	var _class = $VBoxContainer/HBoxContainer/Class/Panel/MenuButton
	_class.get_popup().connect("id_pressed", self, '_on_popup')


func _on_Save_button_up():
	var _name = $VBoxContainer/HBoxContainer/Name.text
	var _class = $VBoxContainer/HBoxContainer/Class/Panel/MenuButton.text
	var rank = $VBoxContainer/HBoxContainer/Rank/SpinBox.value
	var rank01 = $VBoxContainer/ScrollContainer/VBoxContainer/Rank01/VBoxContainer/TextEdit.text
	var rank02 = $VBoxContainer/ScrollContainer/VBoxContainer/Rank02/VBoxContainer/TextEdit.text
	var rank03 = $VBoxContainer/ScrollContainer/VBoxContainer/Rank03/VBoxContainer/TextEdit.text
	emit_signal("receive_talent",_name, _class, rank, rank01, rank02, rank03)


func _on_popup(id):
	var _class = $VBoxContainer/HBoxContainer/Class/Panel/MenuButton
	match id:
		0:
			_class.text = _class.get_popup().get_item_text(id)
		1:
			_class.text = _class.get_popup().get_item_text(id)
		2:
			_class.text = _class.get_popup().get_item_text(id)
		3:
			_class.text = _class.get_popup().get_item_text(id)
		4:
			_class.text = _class.get_popup().get_item_text(id)
		5:
			_class.text = _class.get_popup().get_item_text(id)
		6:
			_class.text = _class.get_popup().get_item_text(id)
		7:
			_class.text = _class.get_popup().get_item_text(id)
		8:
			_class.text = _class.get_popup().get_item_text(id)
		9:
			_class.text = _class.get_popup().get_item_text(id)


func _on_Button_button_up():
	self.queue_free()
