extends HBoxContainer

func _ready():
	self.get_node("MenuButton").get_popup().connect("index_pressed", self, '_on_popup')



func _on_popup(id):
	var button = self.get_node("Button")
	match id:
		0:
			button.text = 'D12'
		1:
			button.text = 'D10'
		2:
			button.text = 'D8'
		3:
			button.text = 'none'
