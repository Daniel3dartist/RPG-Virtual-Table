extends VBoxContainer

onready var talent_creator = preload("res://Scenes/Sheet/Forbidden_Lands/Talents/Talents_Creator.tscn")
onready var talent_panel = preload("res://Scenes/Sheet/Forbidden_Lands/Talents/Talent_Panel.tscn")
onready var talent_list = $'HBoxContainer2/ScrollContainer/VBoxContainer'


func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_released("Del"):
		var talents = $HBoxContainer2/ScrollContainer/VBoxContainer
#		var array: Array
		for i in talents.get_child_count():
			if talents.get_child(i).modulate == Color('#98e0ff'):
				talents.get_child(i).queue_free()


func _on_add_button_up():
	_spaw_talent_panel('add', null, null)
	
	
func _spaw_talent_panel(info, id, _name):
	var tc = talent_creator.instance()
	get_tree().get_root().get_node('Table').get_node('Sheet_Spaw').add_child(tc)
	tc.connect('receive_talent', self, '_on_receive_talent')
	if info == 'add':
		tc.get_node("VBoxContainer/Label").text = 'Talent Creator'
	elif info == 'edit':
		tc.get_node("VBoxContainer/Label").text = 'Talent Editor'
		tc.get_node("VBoxContainer/HBoxContainer/Name").text = _name


func _on_receive_talent(_name, _class,rank,rank01, rank02, rank03):
	var tp = talent_panel.instance()
	talent_list.add_child(tp)
	tp.connect("call_talent", self, '_on_call_talent')
	tp.get_node("HBoxContainer/Talent").text = _name
	tp.get_node("HBoxContainer/Class").text = _class
	tp.get_node("HBoxContainer/Rank").text = 'Rank 0%s' % str(rank)


func _on_call_talent(id, _name):
	_spaw_talent_panel('edit', id, _name)
