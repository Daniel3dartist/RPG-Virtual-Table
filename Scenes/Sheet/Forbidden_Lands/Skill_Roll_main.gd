extends Panel

onready var parent = get_tree().get_root().get_node('Table')
onready var chat = parent.get_node('Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat')

onready var roll_panel = preload("res://Scenes/Sheet/Forbidden_Lands/Roll_Tests.tscn")
var child_list

func _ready():
	parent = get_tree().get_root().get_node('Table')
	chat = parent.get_node('Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat')
	_roll_dice()
	child_list = self.get_node("VBoxContainer")
	for i in child_list.get_child_count():
		child_list.get_child(i).get_child(0).connect("roll_skill", self, "_roll_skill")

func _roll_skill(_name, attribute, level, id):
	print('\n\n\nMain Node: %s\n\n\n' % self.get_tree())
	var panel = roll_panel.instance()
	parent.get_node('Sheet_Spaw').add_child(panel)
	panel.get_node("VBoxContainer/Label").text = _name
	panel.get_node("VBoxContainer/VBoxContainer/Attribut/Label").text = attribute
	panel.get_node("VBoxContainer/VBoxContainer/Attribut/Label2").text = '%s' % 0
	panel.get_node("VBoxContainer/VBoxContainer/Skill/Label2").text = str(child_list.get_child(id).get_child(2).value)
	panel.get_node("VBoxContainer/VBoxContainer/Mods/Label2"). text = '%s' % 0
	_roll_dice()


func _roll_dice():
	var dice = randi() % 6 + 1
	chat.append_bbcode(str(dice) + '\n')
	print('\n\n\nDice Roll: %s\n\n\n' % dice)
