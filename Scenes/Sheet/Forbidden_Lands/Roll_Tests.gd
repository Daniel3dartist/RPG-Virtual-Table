extends Panel

signal add_roll_test_to_chat(string)


onready var attribute = $'VBoxContainer/VBoxContainer/Attribut/Label2'
onready var skill = $'VBoxContainer/VBoxContainer/Skill/Label2'
onready var mod = $'VBoxContainer/VBoxContainer/Mods/Label2'
onready var others = $'VBoxContainer/VBoxContainer/Others/CenterContainer/HBoxContainer/SpinBox'

var roll_history: Dictionary = {
	'attribute': 0,
	'skill': 0,
	'mod': 0,
	'others': 0
}

func _ready():
	dice_roll(1)# This first calling it's jus to made randon work corretly.
				# randin() wallways start from the same number. Its necessary
				# use the func one time to receive a really random number 


func _on_Exit_button_up():
	self.queue_free()


func _on_Roll_Dice_button_up():
	var data = group_data_to_roll()
	emit_signal("add_roll_test_to_chat", data)

func group_data_to_roll():
	var array = [int(attribute.text), int(skill.text), int(mod.text), others.value]
	var string: String = '\n'
	for i in array.size():
		if array[i] != 0:
			var result = dice_roll(array[i])
			match i:
				0:
					roll_history['attribute'] = result
					if array[0] != 0 and array[2] != null:
						string += "Attribute:\n[ %s ] \n" % ', '.join(roll_history['attribute'])
				1:
					roll_history['skill'] = result
					if array[1] != 0 and array[2] != null:
						string += 'skill:\n[ %s ] \n' % ', '.join(roll_history['skill'])
				2:
					roll_history['mod'] = result
					if array[2] != 0 and array[2] != null:
						string += 'Mod:\n[ %s ] \n' % ', '.join(roll_history['mod'])
				3:
					roll_history['others'] = result
					if array[3] != 0 and array[2] != null:
						string += 'Others:\n[ %s ] \n' % ', '.join(roll_history['others'])
	print(string)
	emit_signal("add_roll_test_to_chat", string)
#	return string


func dice_roll(num):
	var array: Array
	for i in num:
		array.append(randi() % 6 + 1)
	return array
