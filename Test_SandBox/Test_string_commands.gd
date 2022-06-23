extends Node

var txt = '<username>Limegolas<1><text>ola mundo<1><token>token01</>3.12,5,25'

func _ready():
	print('TXT: \n%s\n' % txt)
	var t = txt
	var dict : Dictionary
	dict = {
		'username':'',
		'content': '',
		'token':''
	}
	if t.split('<1>'):
		t = t.split('<1>')
		print(t)
		if '<username>' in txt:
			var user
			print(t)
			user = t[0]
			t.remove(0)
			user = user.split('>')
			user.remove(0)
			print(t)
			dict['username'] = user
			if '<text>' in txt:
				var content
				print(t)
				print(txt.find_last('<text>'))
				print(txt.find_last('>txet<'))
				var text : String
				var stri = '<text>'
				var num = txt.find_last('<text>')
				for i in '<text>':
					print(txt.find_last('<text>'))
					text+=txt[num]
					num+=1
					print(txt[num])
					print(text)
				print(text)
				print('erase: ',txt.substr(22,6))
				print(txt[22])
				

				content = t[0]
	
	print(dict)
	print(t)
#	var num = 0
#	for i in t:
#		if num < t.size():
#			print('\n' + t[num] + '\n')
#			if t[num] == '':
#				t.remove(t[num])
#			num +=1
	
#	print('Teste .find().\nResult: \n %s' % T.index('<username>'))



