extends RichTextLabel

onready var chat_input = $'Base_UI/Chat_&_Rolls_Results/VBoxContainer/Chat_Input'


# Called when the node enters the scene tree for the first time.
func _input(event):
	if Input.is_action_just_pressed('enter'):
		var txt = str(chat_input.text)
		self.set_text = txt


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
