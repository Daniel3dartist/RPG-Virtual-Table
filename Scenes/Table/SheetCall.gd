extends Button

var BASE_PATH = OS.get_executable_path().get_base_dir()

onready var name_txt = self.text
onready var path = $'path'

signal call_sheet(value)

func _ready():
	pass

func _on_Sheet_button_up():
	var cfg = ConfigFile.new()
	cfg.load(BASE_PATH + '/data/last_played.ini')
	var table = cfg.get_value('Last Played', 'path')
	cfg.load(table)
	var _path = Array(table.split('/'))
	_path.pop_back()
	_path.push_back('%s/%s.save' % [self.text, self.text])
	_path = '/'.join(_path)
	var dic : Dictionary = {
		'name': self.text,
		'path': str(_path),
		'index': self.get_index()
	}
	emit_signal("call_sheet", dic)
