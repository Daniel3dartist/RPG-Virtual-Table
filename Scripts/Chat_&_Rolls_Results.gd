extends Control


onready var chat = $"Base_UI/Chat_&_Rolls_Results/Chat_Buttons_ChatInput/Chat"
onready var chat_input = $"Base_UI/Chat_&_Rolls_Results/Chat_Buttons_ChatInput/Chat_Input"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	chat_input.connect(Control.text_entered, self, Control.text_entered)


func _input(event):
	
	'# Chat Input'
	if Input.is_action_just_pressed("enter"):
		var rollDice 
		'# Chat roll input'
		if '/r' in chat_input.text:
			rollDice = chat_input.text
			rollDice = rollDice.split(' ')
			rollDice = Array(rollDice)
			
			if rollDice.size() > 1:
				rollDice = rollDice[1]
				rollDice = rollDice.replace('d', '')
				rollDice = int(rollDice)
				
				if rollDice == 3:
					return rolld3()
				if rollDice == 4:
					return rolld4()
				if rollDice == 6:
					return rolld6()
				if rollDice == 8:
					return rolld8()
				if rollDice == 10:
					return rolld10()
				if rollDice == 12:
					return rolld12()
				if rollDice == 20:
					return rolld20()
				if rollDice == 100:
					return rolld100()
		else:		
			return Add_Text_On_Chat()
			
	if Input.is_action_just_released("enter"):
		return Clear_Input_TextBox()
		
func Add_Text_On_Chat():
	var txt
	txt = chat_input.text
	chat.add_text(str(txt) + '\n\n')


func Clear_Input_TextBox():
	chat_input.text = ''

func rolld3():
	var d3v
	d3v = randi() % 3 + 1
	d3v = 'Roll d3 = ' + str(d3v)
	chat.add_text(d3v + '\n\n')

func rolld4():
	var d4v
	d4v = randi() % 4 + 1
	d4v = 'Roll d4 = ' + str(d4v)
	chat.add_text(d4v + '\n\n')

func rolld6():
	var d6v
	d6v = randi() % 6 + 1
	d6v = 'Rolling d6 = ' + str(d6v) 
	chat.add_text(d6v + '\n\n')

func rolld8():
	var d8v
	d8v = randi() % 8 + 1
	d8v = 'Rolling d8 = ' + str(d8v) 
	chat.add_text(d8v + '\n\n')

func rolld10():
	var d10v
	d10v = randi() % 10 + 1
	d10v = 'Rolling d10 = ' + str(d10v) 
	chat.add_text(d10v + '\n\n')

func rolld12():
	var d12v
	d12v = randi() % 12 + 1
	d12v = 'Rolling d12 = ' + str(d12v) 
	chat.add_text(d12v + '\n\n')

func rolld20():
	var d20v
	d20v = randi() % 20 + 1
	print(d20v)
	d20v = 'Rolling d20 = ' + str(d20v) 
	chat.add_text(d20v + '\n\n')

func rolld100():
	var d100v
	d100v = randi() % 100 + 1
	d100v = 'Rolling d100 = ' + str(d100v) 
	chat.add_text(d100v + '\n\n')	




func _on_d3_b_pressed():
	return rolld3()


func _on_d4_b_pressed():
	return rolld4()


func _on_d6_b_pressed():
	return rolld6()


func _on_d8_b_pressed():
	return rolld8()


func _on_d10_b_pressed():
	return rolld10()


func _on_d12_b_pressed():
	return rolld12()


func _on_d20_b_pressed():
	return rolld20()


func _on_d100_b_pressed():
	return rolld100()
