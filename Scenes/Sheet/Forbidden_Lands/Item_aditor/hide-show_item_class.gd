extends Panel

func _ready():
	self.get_node("Panel/HBoxContainer2/HBoxContainer/Hide_show").connect("button_down", self, 'on_button_down')
	self.get_node("Panel/HBoxContainer2/HBoxContainer/Hide_show").connect("toggled", self, 'on_toggle')
	self.rect_min_size.y = 45


func on_toggle(_bool):
	var hide_UI = $VBoxContainer/ScrollContainer
	if _bool == true:
		self.rect_min_size.y = 45
		hide_UI.visible = false
	else:
		self.rect_min_size.y = 133
		hide_UI.visible = true
