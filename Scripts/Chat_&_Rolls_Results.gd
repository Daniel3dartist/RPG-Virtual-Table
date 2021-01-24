extends Control

# Character Sheet vars
onready var sheet_list = $"Base_UI/Chat_&_Rolls_Results/HBoxContainer/SplitSheetList/SheetList"
onready var sheet_spaw = $'Sheet_Spaw'

var sheet_call_h_box = preload('res://Scenes/SheetCallHBox.tscn')
var default_sheet_Call = preload("res://Scenes/SheetCall.tscn")
var default_sheet = preload("res://Scenes/Character_Sheet.tscn")
var sheet_delete_buttom = preload("res://Scenes/DeleteSheet.tscn")
var sheet_num = 00

# Chat vars
onready var chat = $"Base_UI/Chat_&_Rolls_Results/Chat_Buttons_ChatInput/Chat"
onready var chat_input = $"Base_UI/Chat_&_Rolls_Results/Chat_Buttons_ChatInput/Chat_Input"

var text_to_Discord 

# Bot vars
onready var bot = $'Bot/HTTPRequest'
onready var hbt = $'Bot/HTTPRequest/HeartbeatTimer'
onready var ist = $'Bot/HTTPRequest/InvalidSessionTimer'

var token := "#" # Bot token
var client : WebSocketClient
var heartbeat_interval : float
var last_sequence : float
var session_id : String
var heartbeat_ack_received := true
var invalid_session_is_resumable : bool


func _ready() -> void:
	sheet_delete_buttom.connect('button_up', self, '_on_Delete_button_up')
	randomize()
	client = WebSocketClient.new()
	client.connect_to_url("wss://gateway.discord.gg/?v=6&encoding=json")
	client.connect("connection_established", self, "_connection_established")
	client.connect("connection_closed", self, "_connection_closed")
	client.connect("server_close_request", self, "_server_close_request")
	client.connect("data_received", self, "_data_received")
	client.connect("input", self, "_input")
	


func _input(event):
	
	'# Chat Input'
	if Input.is_action_just_pressed("enter"):
		var rollDice 
		
		var query : String
		var message_to_send := {"content" : "Ola mundo" }
		var channel_id
		var packet := client.get_peer(1).get_packet()
		var data := packet.get_string_from_utf8()
		var json_parsed := JSON.parse(data)
		#var dict : Dictionary = json_parsed.result
		var headers := ["Authorization: Bot %s" % token]
		
		text_to_Discord = chat_input.text
		print('text to discord: ' + text_to_Discord)
		
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
		
#		return handle_events()
		channel_id = "780370698508959755"
		print('Text to Discord é: ', text_to_Discord)
		message_to_send = text_to_Discord
		query = JSON.print(message_to_send)
		print('Q: ' + query)
		headers.append("Content-Type: application/json")
		bot.request("https://discord.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
		
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


func _process(_delta : float) -> void:
	# Check if the client is not disconnected, there's no point to poll it if it is
	if client.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		client.poll()
	else:
		# If it is disconnected, try to resume
		client.connect_to_url("wss://gateway.discord.gg/?v=6&encoding=json")
		
	if Input.is_action_just_pressed("enter"):
		var query : String
		var channel_id = "780370698508959755"
		var message_to_send := {"content" : text_to_Discord }
		var headers := ["Authorization: Bot %s" % token]
		
		print('Text to Discord é: ', text_to_Discord)
		
		query = JSON.print(message_to_send)
		print('Q: ' + query)
		headers.append("Content-Type: application/json")
		bot.request("https://discord.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
			

func _connection_established(protocol : String) -> void:
	print("We are connected! Protocol: %s" % protocol)

func _connection_closed(was_clean_close : bool) -> void:
	print("We disconnected. Clean close: %s" % was_clean_close)

func _server_close_request(code : int, reason : String) -> void:
	print("The server requested a clean close. Code: %s, reason: %s" % [code, reason])

func _data_received() -> void:
	var packet := client.get_peer(1).get_packet()
	var data := packet.get_string_from_utf8()
	var json_parsed := JSON.parse(data)
	var dict : Dictionary = json_parsed.result
	var op = str(dict["op"]) # Convert it to string for easier checking
	print(op)
	match op:
		"0": # Opcode 0 Dispatch (Events)
			handle_events(dict)
		
		"9": # Opcode 9 Invalid Session
			invalid_session_is_resumable = dict["d"]
			ist.one_shot = true
			ist.wait_time = rand_range(1, 5)
			ist.start()
		"10": # Opcode 10 Hello
			# Set our timer
			heartbeat_interval = dict["d"]["heartbeat_interval"] / 1000
			hbt.wait_time = heartbeat_interval
			hbt.start()

			var d := {}
			if !session_id:
				# Send Opcode 2 Identify to the Gateway
				d = {
					"op" : 2,
					"d" : { "token" : token, "properties" : {} }
				}
			else:
				# Send Opcode 6 Resume to the Gateway
				d = {
					"op" : 6,
					"d" : { "token" : token, "session_id" : session_id, "seq" : last_sequence}
				}
			send_dictionary_as_packet(d)
		"11": # Opcode 11 Heartbeat ACK
			heartbeat_ack_received = true
			print("We've received a Heartbeat ACK from the gateway.")
		

func _on_HeartbeatTimer_timeout() -> void: # Send Opcode 1 Heartbeat payloads every heartbeat_interval
	if !heartbeat_ack_received:
		# We haven't received a Heartbeat ACK back, so we'll disconnect
		client.disconnect_from_host(1002)
		return
	var d := {"op" : 1, "d" : last_sequence}
	send_dictionary_as_packet(d)
	heartbeat_ack_received = false
	print("We've send a Heartbeat to the gateway.")

func send_dictionary_as_packet(d : Dictionary) -> void:
	var query = to_json(d)
	client.get_peer(1).put_packet(query.to_utf8())

func handle_events(dict : Dictionary) -> void:
	last_sequence = dict["s"]
	var event_name : String = dict["t"]
	print(event_name)
	match event_name:
		"READY":
			session_id = dict["d"]["session_id"]
		"GUILD_MEMBER_ADD":
			var guild_id = dict["d"]["guild_id"]
			var headers := ["Authorization: Bot %s" % token]

			# Get all channels of the guild
			bot.request("https://discord.com/api/guilds/%s/channels" % guild_id, headers)
			var data_received = yield(self, "request_completed") # await
			var channels = JSON.parse(data_received[3].get_string_from_utf8()).result
			var channel_id
			

				
			for channel in channels:
				# Find the first text channel and get its ID
				if str(channel["type"]) == "0":
					channel_id = channel["id"]
					break
			
			if channel_id: # If we found at least one text channel
				var username = dict["d"]["user"]["username"]
				var message_to_send := {"content" : "Welcome %s!" % username}
				var query := JSON.print(message_to_send)
				headers.append("Content-Type: application/json")
				bot.request("https://discord.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
		"MESSAGE_CREATE":
			var channel_id = dict["d"]["channel_id"]
			var message_content = dict["d"]["content"]

			var headers := ["Authorization: Bot %s" % token, "Content-Type: application/json"]
			var query : String


#			if message_content.to_upper() == "ORAMA":
#				var message_to_send := {"content" : "Interactive"}
#				var message_to_send := {"content" : "interact" }
#				query = JSON.print(message_to_send)
#				print('canal: ' + str(channel_id))
#				print('headers: ' + str(headers))
#				print('query: ' + str(query))
			
			
			var txt = str(message_content)
			print("Essa é a mensagem content: " + txt)
			print('Esse é o texto para o Discord: ' + text_to_Discord)
				
			if txt != text_to_Discord:
				txt = txt + '\n\n'
				chat.add_text(txt)
						
			if query:
				bot.request("https://discord.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)

func _on_InvalidSessionTimer_timeout() -> void:
	var d := {}
	if invalid_session_is_resumable && session_id:
		# Send Opcode 6 Resume to the Gateway
		d = {
			"op" : 6,
			"d" : { "token" : token, "session_id" : session_id, "seq" : last_sequence}
		}
	else:
		# Send Opcode 2 Identify to the Gateway
		d = {
			"op" : 2,
			"d" : { "token" : token, "properties" : {} }
		}
	send_dictionary_as_packet(d)

# Button for add Character Sheet
func _on_Sheet_Creator_button_up():
	return Creat_Character_Sheet()

# Function for creat a Character Sheet on Table	
func Creat_Character_Sheet():
	var sheet_box_instance = sheet_call_h_box.instance()
	var sheet_call_instance = default_sheet_Call.instance()
	
	var txt = 'Sheet'
	
	if sheet_num > 0:
		txt = txt + ('(%s)' % str(sheet_num))
	
	sheet_call_instance.text = txt
	sheet_box_instance.add_child(sheet_call_instance)
	sheet_list.add_child(sheet_box_instance)
	sheet_num = sheet_num + 1

func _on_call_Sheeet(name_txt):
	var sheet_instance = default_sheet.instance()
	
	sheet_spaw.add_child(sheet_instance)
	
func _on_Delete_button_up():
	sheet_num = sheet_num - 1
	print('Sheet deleted. \n Sheets = %s' % str(sheet_num))
