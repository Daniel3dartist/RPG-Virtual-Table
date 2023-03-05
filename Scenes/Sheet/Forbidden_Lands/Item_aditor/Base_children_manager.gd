extends VBoxContainer


var range_button
var body_type

func _ready():
	if self.name == "Armor":
		body_type = self.get_node("../Armor/HBoxContainer2/Body_Part/MenuButton")
		body_type.get_popup().connect("id_pressed", self, '_Popup_body_part')
	else:
		range_button = self.get_node("HBoxContainer2/Range/MenuButton")
		range_button.get_popup().connect("id_pressed", self, '_Popup_id_pressed')

func _Popup_id_pressed(id):
	match id:
		0:
			range_button.text = '%s [v]' % range_button.get_popup().get_item_text(id)
		1:
			range_button.text = '%s [v]' % range_button.get_popup().get_item_text(id)
		2:
			range_button.text = '%s [v]' % range_button.get_popup().get_item_text(id)
		3:
			range_button.text = '%s [v]' % range_button.get_popup().get_item_text(id)
		4:
			range_button.text = '%s [v]' % range_button.get_popup().get_item_text(id)


func _Popup_body_part(id):
	match id:
		0:
			body_type.text = '%s [v]' % body_type.get_popup().get_item_text(id)
		1:
			body_type.text = '%s [v]' % body_type.get_popup().get_item_text(id)
		2:
			body_type.text = '%s [v]' % body_type.get_popup().get_item_text(id)
