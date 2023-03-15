extends HBoxContainer

signal delete_sheet(index, _name)
signal call_sheet(dic)
signal update_sheet_buttom(array)

var _name 

func _ready():
	_name = $'Sheet'.text

func _on_Delete_button_up():
	var dir = Directory.new()
	dir.remove($'path'.text)
	emit_signal("delete_sheet", self.get_index(), $Sheet.text)
	self.queue_free()


func _on_Sheet_button_up():
	_Pop_sheet()
	
	
func _Pop_sheet():
	var dic : Dictionary = {
		'id': self.get_index(),
		'path': $'path'.text,
		'name': $'Sheet'.text
	}
	emit_signal("call_sheet", dic)


func _on_Sheet_renamed():
	pass

func _Save_sheet_path(value):
	var path = $'path'.text
	$'path'.text = value[1]
	#if value[0] != value[1]:
	#	emit_signal('update_sheet_buttom',[self.get_index(), $'Sheet'.text, value[0], value[1]])
