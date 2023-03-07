extends Panel

onready var hide_UI = $VBoxContainer/ScrollContainer

func _ready():
	var hide_show = self.get_node("Panel/HBoxContainer2/HBoxContainer/Hide_show")
	hide_show.connect("button_down", self, 'on_button_down')
	hide_show.connect("toggled", self, 'on_toggle')
	self.rect_min_size.y = 45
	hide_UI.visible = false
	


func on_toggle(_bool):
	if _bool == true:
		self.rect_min_size.y = 45
		hide_UI.visible = false
	else:
		self.rect_min_size.y = 133
		hide_UI.visible = true
