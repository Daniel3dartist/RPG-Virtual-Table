extends Panel

var BASE_PATH = OS.get_executable_path().get_base_dir()

onready var parent = get_tree().get_root().get_node('Table')
onready var chat = parent.get_node('Base_UI/Chat_&_Rolls_Results/TabContainer/Chat_Buttons_ChatInput/Chat')

onready var attribute = $'VBoxContainer/VBoxContainer/Attribut/Label2'
onready var skill = $'VBoxContainer/VBoxContainer/Skill/Label2'
onready var mod = $'VBoxContainer/VBoxContainer/Mods/Label2'
onready var others = $'VBoxContainer/VBoxContainer/Others/CenterContainer/HBoxContainer/SpinBox'

var app_username
var user_color = '#6eff90'

var roll_history: Dictionary = {
	'attribute': 0,
	'skill': 0,
	'mod': 0,
	'others': 0
}


var d6 = ["res://Scenes/Dices/d6_img/1.png", "res://Scenes/Dices/d6_img/2.png", "res://Scenes/Dices/d6_img/3.png", "res://Scenes/Dices/d6_img/4.png", "res://Scenes/Dices/d6_img/5.png", "res://Scenes/Dices/d6_img/6.png"]


func _ready():
	var cfg = ConfigFile.new()
	cfg.load(BASE_PATH + '/data/user_settings.ini')
	app_username = "[color=%s]%s[/color]:\n" % [user_color, cfg.get_value("User", "Nickname")]
	dice_roll(1)# This first calling it's jus to made randon work corretly.
				# randin() wallways start from the same number. Its necessary
				# use the func one time to receive a really random number 


func _on_Exit_button_up():
	self.queue_free()


func _on_Roll_Dice_button_up():
	group_data_to_roll()


func group_data_to_roll():
	var title = self.get_node('VBoxContainer/Label').text
	var array = [int(attribute.text), int(skill.text), int(mod.text), others.value]
	var string: String = '%s' % app_username
	var string02: String
	for i in array.size():
		if array[i] != 0:
			var result = dice_roll(array[i])
			var dices: String
			match i:
				0:
					roll_history['attribute'] = result
					if array[0] != 0 and array[2] != null:
						for x in result.size():
							var num = result[x]
							dices += '[img=<width>52x52<height>]%s[/img] ' % d6[num-1]
						string02 += "%s:\n%s \n" % [ attribute.get_parent().get_node("Label").text, dices]
						print('Results: ',result)
				1:
					roll_history['skill'] = result
					if array[1] != 0 and array[2] != null:
						for x in result.size():
							var num = result[x]
							dices += '[img=<width>52x52<height>]%s[/img] ' % d6[num-1]
						string02 += "%s:\n%s \n" % [skill.get_parent().get_node("Label").text, dices]
						print('Results: ',result)
				2:
					roll_history['mod'] = result
					if array[2] != 0 and array[2] != null:
						for x in result.size():
							var num = result[x]
							dices += '[img=<width>52x52<height>]%s[/img] ' % d6[num-1]
						string02 += "%s:\n%s \n" % [mod.get_parent().get_node("Label").text, dices]
						print('Results: ',result)
				3:
					roll_history['others'] = result
					if array[3] != 0 and array[2] != null:
						for x in result.size():
							var num = result[x]
							dices += '[img=<width>52x52<height>]%s[/img] ' % d6[num-1]
						string02 += "%s:\n%s \n" % [others.get_parent().get_parent().get_parent().get_node("Label").text, dices]
						print('Results: ',result)
	string += '[center]%s[/center]\n[indent]%s[/indent]\n' %[title, string02]
	print(string)
	chat.append_bbcode(string)
#	return string


func dice_roll(num):
	var array: Array
	for i in num:
		array.append(randi() % 6 + 1)
	return array
