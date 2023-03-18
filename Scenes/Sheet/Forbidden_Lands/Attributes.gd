extends Panel

var points_check
var _str = 'HBoxContainer/Attributes_Column/Strength_Line'
var _agi = 'HBoxContainer/Attributes_Column/Agility_Line'
var _wits = 'HBoxContainer/Attributes_Column/Wits_Line'
var _emp = "HBoxContainer/Attributes_Column/Empathy_Line"
var points = '/Panel/HboxContainer/Points_Input/Panel/SpinBox2'
var current_points = '/Panel/HboxContainer/Points_Input/SpinBox'
var check_points = "/Panel/HboxContainer/Points"
var can_change: bool = false
var attributes = [_str, _agi, _wits, _emp]

var str_points = {
	'points': 0,
	'current_points': 0
}

func _ready():
	var main = $"../../../../../../../../../.."
	main.connect("_set_att", self, "_set_att")


func _input(event):
	if Input.is_action_just_released("left_mouse") or Input.is_action_just_released("enter"):
		_check_attributes()

func _check_attributes():
	for i in attributes.size():
		points_check = self.get_node(attributes[int(i)] + check_points)
		var current = attributes[int(i)] + current_points
		var total = attributes[int(i)] + points
		_attributes_manipulations(current, total)


func _attributes_manipulations(current, total):
	current = self.get_node(current)
	total = self.get_node(total)
	var num01 = current.value
	var num02 = total.value
	current.max_value = num02
	var _bool: bool
	var is_disabled: bool
	if num01 == num02:
		for i in points_check.get_child_count():
			if i <= (num02 - 1):
				is_disabled = false
				_bool = true
			else:
				_bool = false
				is_disabled = true
			points_check.get_child(i).modulate = 'ffffff'
			points_check.get_child(i).pressed = _bool
			points_check.get_child(i).disabled = is_disabled
	elif num01 < num02:
		var diference = num01 - num02
		for i in num02:
			if i > (num01 - 1):
				_bool = false
#				is_disabled = true
				points_check.get_child(i).modulate = '#fd7575'
			else:
				is_disabled = false
				_bool = true
				points_check.get_child(i).modulate = 'ffffff'
			points_check.get_child(i).pressed = _bool
			points_check.get_child(i).disabled = is_disabled


func _set_att():
	_check_attributes()
