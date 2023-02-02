extends Button

onready var name_txt = self.text
onready var path = $'path'

signal call_sheet(value)

func _ready():
	pass

func _on_Sheet_button_up():
	var dic : Dictionary = {
		'name': self.text,
		'path': path.text,
		'index': self.get_index()
	}
	emit_signal("call_sheet", dic)
