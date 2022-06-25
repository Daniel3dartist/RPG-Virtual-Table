extends Node

var txt = '<username>Limegolas</username><1><text>ola mundo</text><token>token01</>3.12,5,25</token>'

func _ready():
	print('TXT: \n%s\n' % txt)
	var t = txt
	var dict : Dictionary
	dict = {
		'username':'',
		'content': '',
		'token':''
	}
	var user_ = '<username>'
	var _user = '</username>'
	var text_ = txt.find_last('<text>')
	var _text = txt.find_last('</text>')
	
	if '<username>' in txt and '</username>' in txt:
		# K from "Key"
		var k1 = txt.find_last(user_)
		var k2 = txt.find_last(_user)
		var leng
		k1 += user_.length()
		leng = k2 - k1
		print(txt.substr(k1, leng))
		dict['user'] = txt.substr(k1, leng)
	print(dict['user'])

	_text = _text + '<text>'.length()
	var leng = _text - text_ 
	print(txt.substr(text_, leng))



