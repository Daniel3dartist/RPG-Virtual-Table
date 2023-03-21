extends CheckBox


onready var container = self.get_parent().get_parent().get_node("ScrollContainer")
onready var parent = self.get_parent().get_parent()

func _ready():
	self.connect("pressed", self, '_pressed')


func _pressed():
	if container.visible == true:
		container.visible = false
#		container.rect_min_size.y = 300
		parent.rect_min_size.y = 130
	else:
		container.visible = true
		container.rect_min_size.y = 300
		parent.rect_min_size.y = 300
