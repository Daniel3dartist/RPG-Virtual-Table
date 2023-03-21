extends ScrollContainer

onready var parent = self.get_parent()

func _ready():
	var checker = self.get_parent().get_node("HBoxContainer/Hide_show")
	checker.connect("pressed", self, "_pressed")

func _pressed():
	if self.visible == false:
		self.visible = true
		parent.rect_min_size.y = 300
	else:
		self.visible = false
		parent.rect_min_size.y = 130
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
