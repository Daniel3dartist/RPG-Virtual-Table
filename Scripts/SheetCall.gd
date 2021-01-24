extends Button

onready var name_txt = self.text

signal call_sheet()

var sheet = preload("res://Scenes/Character_Sheet.tscn")
var table = load("res://Scenes/Table.tscn")


func _on_Sheet_button_up():
	emit_signal("call_sheet", name_txt)
	
	#var sheet_instance = sheet.instance()
	#var table_instance = table.instance()
	#table_instance.add_child(sheet_instance)
